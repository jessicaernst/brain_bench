import 'dart:async';
import 'dart:io';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/storage/storage_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

final _logger = Logger('ProfileNotifier');

/// This class represents the notifier for the profile state in the application.
/// It extends the generated `_$ProfileNotifier` class.
/// The `ProfileNotifier` class is responsible for updating the user's profile,
/// including the display name and profile image.
/// It handles the logic for image compression, validation, and uploading,
/// as well as updating the database with the new profile information.
/// It also manages the state of the profile update operation,
/// indicating whether it is loading, successful, or has encountered an error.
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<void> build() {}

  /// Fetches and validates the current user's ID.
  /// Sets the state to error and returns null if the user ID is not available.
  String? _getUserIdAndSetErrorStateIfAbsent() {
    final AsyncValue<AppUser?> authUserAsyncValue = ref.read(
      currentUserProvider,
    );
    final String? userId = authUserAsyncValue.valueOrNull?.uid;

    if (userId == null || userId.isEmpty) {
      final error = Exception(
        'User not authenticated or user ID not available',
      );
      _logger.warning('Profile update failed: ${error.toString()}');
      state = AsyncError(error, StackTrace.current);
      return null;
    }
    _logger.fine('User ID obtained: $userId');
    return userId;
  }

  /// Validates the image file extension.
  String? _validateImageExtension(File profileImageFile) {
    const List<String> validExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'heic',
      'heif',
      'bmp',
    ];
    String fileExtension = '';
    final int dotIndex = profileImageFile.path.lastIndexOf('.');

    if (dotIndex != -1 && dotIndex < profileImageFile.path.length - 1) {
      fileExtension =
          profileImageFile.path.substring(dotIndex + 1).toLowerCase();
    }

    if (!validExtensions.contains(fileExtension)) {
      final errorMsg =
          'Invalid image format. Please select a JPG, PNG, GIF, WEBP, or BMP.';
      _logger.warning(
        'Invalid image file type for upload: "$fileExtension". Error: $errorMsg',
      );
      return errorMsg;
    }
    return null;
  }

  /// Attempts to compress the image file.
  /// Returns the file to upload (either compressed or original) and any temporary compressed file.
  Future<({File imageForUpload, File? tempCompressedFile})> _tryCompressImage(
    File profileImageFile,
  ) async {
    File imageForUpload = profileImageFile;
    File? tempCompressedFile;
    Directory? tempDir;
    try {
      tempDir = await getTemporaryDirectory();
      final String originalFileNameWithoutExt = p.basenameWithoutExtension(
        profileImageFile.path,
      );
      final String originalExtension =
          p.extension(profileImageFile.path).toLowerCase();

      CompressFormat targetFormat = CompressFormat.jpeg;
      String targetFileExtension = '.jpg';

      // Preserve original format if it supports transparency and is supported for output
      if (originalExtension == '.png') {
        targetFormat = CompressFormat.png;
        targetFileExtension = '.png';
      } else if (originalExtension == '.webp') {
        targetFormat = CompressFormat.webp;
        targetFileExtension = '.webp';
      } else if (originalExtension == '.gif') {
        // Compress GIF to PNG to preserve transparency, as direct GIF compression isn't typical
        targetFormat = CompressFormat.png;
        targetFileExtension = '.png';
      } else if (originalExtension == '.heic' || originalExtension == '.heif') {
        // Convert HEIC/HEIF to PNG during compression.
        // This ensures broader compatibility for the output file and handles potential transparency,
        // as direct HEIC output support via FlutterImageCompress might vary across platforms
        // or lead to mis-extended files if the library silently falls back.
        _logger.info('Input is HEIC/HEIF, will compress to PNG format.');
        targetFormat = CompressFormat.png;
        targetFileExtension = '.png';
      }

      final String targetFileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}_$originalFileNameWithoutExt$targetFileExtension';
      // If getTemporaryDirectory failed, tempDir would be null and an exception caught.
      final String targetPath = p.join(tempDir.path, targetFileName);

      _logger.fine(
        'Attempting to compress image to: $targetPath, target format: $targetFormat',
      );
      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            profileImageFile.absolute.path,
            targetPath,
            quality: 80,
            minWidth: 800,
            minHeight: 800,
            format: targetFormat,
          );
      if (compressedXFile != null) {
        imageForUpload = File(compressedXFile.path);
        tempCompressedFile = imageForUpload;
        _logger.info(
          'Image compressed successfully (format: $targetFormat). New path: ${imageForUpload.path}, Size: ${await imageForUpload.length()} bytes',
        );
      } else {
        _logger.warning(
          'Image compression returned null. Using original file for upload.',
        );
      }
    } on MissingPlatformDirectoryException catch (e, stack) {
      _logger.severe(
        'Failed to obtain temporary directory due to a platform issue (e.g., not supported or unavailable). Using original file.',
        e,
        stack,
      );
      // tempDir would be null or its pre-await value if getTemporaryDirectory() threw.
      // The original image is used by default as imageForUpload is initialized with it.
    } catch (e, stack) {
      // This will catch other errors, including if getTemporaryDirectory() threw
      // an exception other than MissingPlatformDirectoryException, or if an error
      // occurred during the compression process itself.
      if (tempDir == null) {
        _logger.severe(
          'Failed to obtain temporary directory for image compression (general error). Using original file.',
          e,
          stack,
        );
      } else {
        // This case means tempDir was obtained, but an error occurred later (e.g., during compression).
        _logger.severe(
          'Error during image compression (temp dir was ${tempDir.path}). Using original file.',
          e,
          stack,
        );
      }
    }
    return (
      imageForUpload: imageForUpload,
      tempCompressedFile: tempCompressedFile,
    );
  }

  /// Validates the file size of the image to be uploaded.
  Future<String?> _validateImageFileSize(
    File imageToCheck,
    File originalImageFile,
  ) async {
    final int currentFileSize = await imageToCheck.length();
    const int maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    if (currentFileSize > maxSizeInBytes) {
      final errorMsg =
          'Image is too large even after compression. Maximum size is 5MB.';
      _logger.warning(
        'Image (after potential compression) is too large for upload: ${currentFileSize / (1024 * 1024)}MB. Original size was: ${await originalImageFile.length() / (1024 * 1024)}MB. Error: $errorMsg',
      );
      return errorMsg;
    }
    return null;
  }

  /// Uploads the image to storage and returns the URL.
  Future<String?> _uploadImageToStorageAndGetUrl(
    String userId,
    File imageToUpload,
    StorageRepository storageRepository,
  ) async {
    try {
      final String uploadedUrl = await storageRepository.uploadProfileImage(
        userId,
        imageToUpload,
      );
      _logger.info('Profile image uploaded successfully. URL: $uploadedUrl');
      return uploadedUrl;
    } catch (e, stack) {
      _logger.severe(
        'Failed to upload profile image for user $userId. Error: ${e.toString()}',
        e,
        stack,
      );
      return null; // Indicates upload failure
    }
  }

  /// Cleans up (deletes) a temporary image file if it exists and is different from the original.
  Future<void> _cleanupTemporaryImageFile(
    File? tempFile,
    File originalFile,
  ) async {
    if (tempFile != null && tempFile.path != originalFile.path) {
      try {
        await tempFile.delete();
        _logger.info('Deleted compressed temporary file: ${tempFile.path}');
      } catch (e) {
        _logger.warning('Could not delete compressed temporary file: $e');
      }
    }
  }

  /// Handles image validation, compression, upload, and temporary file cleanup.
  /// Returns the URL of the uploaded image and any error message.
  Future<({String? uploadedPhotoUrl, String? error})>
  _handleImageProcessingAndUpload({
    required File profileImageFile,
    required String userId,
    required StorageRepository storageRepository,
  }) async {
    _logger.info(
      'New profile image provided. Original path: ${profileImageFile.path}',
    );

    String? error = _validateImageExtension(profileImageFile);
    if (error != null) return (uploadedPhotoUrl: null, error: error);

    final compressionResult = await _tryCompressImage(profileImageFile);
    final File imageToUpload = compressionResult.imageForUpload;
    final File? tempCompressedFile = compressionResult.tempCompressedFile;

    error = await _validateImageFileSize(imageToUpload, profileImageFile);
    if (error != null) {
      await _cleanupTemporaryImageFile(tempCompressedFile, profileImageFile);
      return (uploadedPhotoUrl: null, error: error);
    }

    final String? uploadedUrl = await _uploadImageToStorageAndGetUrl(
      userId,
      imageToUpload,
      storageRepository,
    );
    await _cleanupTemporaryImageFile(tempCompressedFile, profileImageFile);

    if (uploadedUrl == null) {
      return (uploadedPhotoUrl: null, error: 'Image upload failed.');
    }
    return (uploadedPhotoUrl: uploadedUrl, error: null);
  }

  /// Updates the user's profile in the database.
  /// Returns the photo URL that was in the database before this update.
  Future<String?> _performDatabaseUpdate({
    required String userId,
    required String? displayName,
    required String? photoUrlToStoreInDb,
    required UserRepository userRepository,
  }) async {
    _logger.info(
      'Calling updateUserProfile for user $userId with name: $displayName and photoUrl: ${photoUrlToStoreInDb ?? "(no change)"}',
    );
    // Call updateUserProfile on the UserRepository
    await userRepository.updateUserProfile(
      userId: userId,
      displayName: displayName,
      photoUrl: photoUrlToStoreInDb,
    );
    _logger.info('Profile update successful in repository for user $userId.');
    // updateUserProfile in UserRepository does not return the old photoUrl.
    // If needed, it should be fetched before this call. For now, we return null or adapt.
    return null; // This method no longer returns the old photoUrl
  }

  /// Attempts to delete the old profile image from storage.
  Future<void> _attemptOldImageDeletion({
    required String? newUploadedPhotoUrl,
    required String? photoUrlFromDbBeforeUpdate,
    required String userId,
    required StorageRepository storageRepository,
    required UserRepository userRepository,
  }) async {
    if (photoUrlFromDbBeforeUpdate != null &&
        photoUrlFromDbBeforeUpdate.isNotEmpty &&
        photoUrlFromDbBeforeUpdate != newUploadedPhotoUrl) {
      AppUser? latestUserDataAfterUpdate;
      String? currentLivePhotoUrlInDb;
      bool canProceedWithDeletionLogic = true;

      try {
        latestUserDataAfterUpdate = await userRepository.getUser(userId);
        currentLivePhotoUrlInDb = latestUserDataAfterUpdate?.photoUrl;
        _logger.fine(
          'Pre-deletion check: Current live photoUrl in DB for user $userId is $currentLivePhotoUrlInDb',
        );
      } catch (e, stack) {
        _logger.warning(
          'Failed to re-fetch user data for pre-deletion check for user $userId. Skipping deletion of $photoUrlFromDbBeforeUpdate to be safe.',
          e,
          stack,
        );
        canProceedWithDeletionLogic = false;
      }

      if (canProceedWithDeletionLogic) {
        if (photoUrlFromDbBeforeUpdate == currentLivePhotoUrlInDb) {
          _logger.warning(
            'Skipping deletion of $photoUrlFromDbBeforeUpdate for user $userId because it is currently the live photoUrl. This might indicate a rapid revert or concurrent update.',
          );
        } else {
          try {
            _logger.info(
              'Attempting to delete old profile image (obtained from DB pre-update, and confirmed not current live): $photoUrlFromDbBeforeUpdate',
            );
            final oldImageRef = storageRepository.storageInstance.refFromURL(
              photoUrlFromDbBeforeUpdate,
            );
            await oldImageRef.delete();
            _logger.info(
              'Old profile image (obtained from DB pre-update) deleted successfully: $photoUrlFromDbBeforeUpdate',
            );
          } catch (e, stack) {
            _logger.warning(
              'Failed to delete old profile image: $photoUrlFromDbBeforeUpdate',
              e,
              stack,
            );
          }
        }
      }
    }
  }

  Future<void> updateProfile({
    required String displayName,
    File? profileImageFile,
  }) async {
    state = const AsyncLoading();
    _logger.fine('Attempting to update profile...');

    try {
      final UserRepository userRepository = await ref.read(
        userFirebaseRepositoryProvider,
      );
      final StorageRepository storageRepository = ref.read(
        storageRepositoryProvider,
      );

      final String? userId = _getUserIdAndSetErrorStateIfAbsent();
      if (userId == null) return;

      final AppUser? userBeforeUpdate = await userRepository.getUser(userId);
      final String? photoUrlFromDbBeforeUpdate = userBeforeUpdate?.photoUrl;

      String? finalPhotoUrlToStoreInDb;
      String? newUploadedPhotoUrl;
      String? imageProcessingError;

      if (profileImageFile != null) {
        _logger.fine('Processing new profile image file for user $userId.');
        final imageResult = await _handleImageProcessingAndUpload(
          profileImageFile: profileImageFile,
          userId: userId,
          storageRepository: storageRepository,
        );
        newUploadedPhotoUrl = imageResult.uploadedPhotoUrl;
        imageProcessingError = imageResult.error;

        _logger.fine(
          'Image processing result for user $userId: newUploadedPhotoUrl=$newUploadedPhotoUrl, error=$imageProcessingError',
        );

        if (imageProcessingError != null) {
          state = AsyncError(
            Exception(imageProcessingError),
            StackTrace.current,
          );
          return;
        }

        finalPhotoUrlToStoreInDb = newUploadedPhotoUrl;
      }

      await _performDatabaseUpdate(
        userId: userId,
        displayName: displayName,
        photoUrlToStoreInDb: finalPhotoUrlToStoreInDb,
        userRepository: userRepository,
      );

      ref.invalidate(currentUserModelProvider);
      _logger.fine('Invalidated currentUserModelProvider.');

      if (newUploadedPhotoUrl != null && imageProcessingError == null) {
        unawaited(
          _attemptOldImageDeletion(
            newUploadedPhotoUrl: newUploadedPhotoUrl,
            photoUrlFromDbBeforeUpdate: photoUrlFromDbBeforeUpdate,
            userId: userId,
            storageRepository: storageRepository,
            userRepository: userRepository,
          ),
        );
      }

      if (!state.isLoading && state is! AsyncData) {
        state = const AsyncData(null);
        _logger.info(
          'ProfileNotifier: Set state to AsyncData for user $userId. Returning cleanly.',
        );
      } else {
        _logger.warning(
          'State was already completed. Skipping redundant state set.',
        );
      }
    } catch (e, stack) {
      final userIdForLog =
          ref.read(currentUserProvider).valueOrNull?.uid ?? 'unknown';
      _logger.severe(
        'ProfileNotifier: CAUGHT ERROR in updateProfile for user $userIdForLog. Error: $e. State upon entering catch: $state',
        e,
        stack,
      );

      if (state is! AsyncError) {
        state = AsyncError(e, stack);
      }
      return Future.error(e, stack);
    }
  }

  /// Updates only the user's profile image.
  ///
  /// If [newImageFile] is provided, it will be compressed, uploaded,
  /// and the user's photoUrl will be updated.
  /// This is useful for auto-saving a provisionally displayed image (e.g., from contacts).
  ///
  /// Note: This method does NOT update the display name.
  Future<void> updateUserProfileImage({
    required XFile newImageFile,
    required String userId,
  }) async {
    _logger.info('Attempting to auto-update profile image for user $userId.');
    // We don't set state to loading here to avoid interfering with other UI states
    // that might be watching the main profileNotifierProvider state for the full profile update.
    // This is a background operation triggered by ensureUserExistsIfNeeded.
    try {
      final File imageFileToProcess = File(newImageFile.path);

      final (:imageForUpload, :tempCompressedFile) = await _tryCompressImage(
        imageFileToProcess,
      );

      final String? newImageUrl = await _uploadImageToStorageAndGetUrl(
        userId,
        imageForUpload,
        ref.read(storageRepositoryProvider), // Pass the storage repository
      );

      // Only update photoUrl in the database
      await _performDatabaseUpdate(
        userId: userId,
        displayName: null, // Pass null if display name should not be changed
        photoUrlToStoreInDb: newImageUrl,
        userRepository: await ref.read(userFirebaseRepositoryProvider),
      );

      await _cleanupTemporaryImageFile(tempCompressedFile, imageFileToProcess);

      _logger.info('Profile image auto-updated successfully for user $userId.');
      ref.invalidate(currentUserModelProvider);
    } catch (e, stack) {
      _logger.severe(
        'Error auto-updating profile image for user $userId',
        e,
        stack,
      );
    }
  }

  /// Attempts to delete the current user's account.
  ///
  /// Sets the notifier state to [AsyncLoading] while the operation is in progress.
  /// If successful, sets the state to [AsyncData] (with null value) and returns `true`.
  /// If an error occurs, sets the state to [AsyncError] and returns `false`.
  /// The UI should listen to the notifier's state for detailed error information
  /// and react to the boolean return value for immediate success/failure feedback.
  Future<bool> deleteUserAccount() async {
    _logger.info('Attempting to delete user account...');
    state = const AsyncLoading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.deleteAccount();
      _logger.info(
        'User account deletion initiated successfully via repository.',
      );

      if (!state.isLoading && state is! AsyncData) {
        state = const AsyncData(null);
      } else {
        _logger.warning(
          'deleteUserAccount(): Skipping redundant state assignment.',
        );
      }

      return true;
    } catch (e, s) {
      _logger.severe('Failed to delete user account', e, s);
      // If the state is already loading or has an error, we don't overwrite it.
      if (!state.isLoading && state is! AsyncError) {
        state = AsyncError(e, s);
      }

      return false;
    }
  }
}
