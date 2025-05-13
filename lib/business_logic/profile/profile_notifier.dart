import 'dart:io';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/storage/storage_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

final _logger = Logger('ProfileNotifier');

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> updateProfile({
    required String displayName,
    File? profileImageFile,
  }) async {
    state = const AsyncLoading();
    _logger.fine('Attempting to update profile...');

    try {
      // 1. Get the Database Repository (asynchronously)
      final DatabaseRepository dbRepository = await ref.read(
        quizMockDatabaseRepositoryProvider.future,
      );
      // Get the Storage Repository
      final StorageRepository storageRepository = ref.read(
        storageRepositoryProvider,
      );

      // 2. Get the current authentication state's AppUser? value
      //    Reading the latest value emitted by the currentUserProvider stream.
      //    This assumes the stream has emitted a value for the logged-in user.
      final AsyncValue<AppUser?> authUserAsyncValue = ref.read(
        currentUserProvider,
      );

      // 3. Extract the userId from the auth state AppUser
      //    valueOrNull safely gets the data if available, otherwise null.
      final String? userId = authUserAsyncValue.valueOrNull?.uid;

      // 4. Check if userId could be obtained (user is logged in and stream has emitted)
      if (userId == null || userId.isEmpty) {
        // This could happen if the user is not logged in, or the stream hasn't emitted yet.
        final error = Exception(
          'User not authenticated or user ID not available',
        );
        _logger.warning('Profile update failed: ${error.toString()}');
        state = AsyncError(error, StackTrace.current);
        return;
      }

      // photoUrlToStoreInDb will be the URL passed to updateUserProfile.
      // It's null initially, meaning "no change" to photo URL unless a new image is successfully uploaded.
      String? photoUrlToStoreInDb;
      String? uploadedPhotoUrl;

      String? imageUploadError;
      if (profileImageFile != null) {
        _logger.info(
          'New profile image provided. Original path: ${profileImageFile.path}',
        );

        const List<String> validExtensions = [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'bmp',
        ];
        String fileExtension = '';
        final int dotIndex = profileImageFile.path.lastIndexOf('.');

        if (dotIndex != -1 && dotIndex < profileImageFile.path.length - 1) {
          fileExtension =
              profileImageFile.path.substring(dotIndex + 1).toLowerCase();
        }

        if (!validExtensions.contains(fileExtension)) {
          _logger.warning(
            'Invalid image file type for upload: "$fileExtension"',
          );
          imageUploadError =
              'Invalid image format. Please select a JPG, PNG, GIF, WEBP, or BMP.';
          state = AsyncError(Exception(imageUploadError), StackTrace.current);
          return;
        }

        File imageToUpload = profileImageFile; // Start with the original file
        File? tempCompressedFile; // To keep track of the temp file for deletion

        // Attempt to compress the image
        try {
          final targetPath =
              '${profileImageFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}_${profileImageFile.path.split('/').last}';
          _logger.fine('Attempting to compress image to: $targetPath');

          final XFile? compressedXFile =
              await FlutterImageCompress.compressAndGetFile(
                profileImageFile.absolute.path,
                targetPath,
                quality: 80,
                minWidth: 800,
                minHeight: 800,
              );

          if (compressedXFile != null) {
            imageToUpload = File(compressedXFile.path);
            tempCompressedFile = imageToUpload;
            _logger.info(
              'Image compressed successfully. New path: ${imageToUpload.path}, Size: ${await imageToUpload.length()} bytes',
            );
          } else {
            _logger.warning(
              'Image compression returned null. Using original file for upload.',
            );
          }
        } catch (e, stack) {
          _logger.severe('Error during image compression', e, stack);
        }

        final int fileSizeAfterCompression = await imageToUpload.length();
        const int maxSizeInBytes = 5 * 1024 * 1024;
        if (fileSizeAfterCompression > maxSizeInBytes) {
          _logger.warning(
            'Image (after potential compression) is too large for upload: ${fileSizeAfterCompression / (1024 * 1024)}MB. Original size was: ${await profileImageFile.length() / (1024 * 1024)}MB',
          );
          imageUploadError =
              'Image is too large even after compression. Maximum size is 5MB.';
          state = AsyncError(Exception(imageUploadError), StackTrace.current);
          if (tempCompressedFile != null &&
              tempCompressedFile.path != profileImageFile.path) {
            await tempCompressedFile.delete();
          }
          return;
        }

        // Attempt to upload the (potentially compressed) image
        // Proceed only if no prior error (like compression error we want to signal)
        try {
          uploadedPhotoUrl = await storageRepository.uploadProfileImage(
            userId,
            imageToUpload,
          );
          _logger.info(
            'Profile image uploaded successfully. URL: $uploadedPhotoUrl',
          );
          // If upload was successful, this is the URL we want to store in the database.
          photoUrlToStoreInDb = uploadedPhotoUrl;
        } catch (e, stack) {
          _logger.severe(
            'Failed to upload profile image for user $userId',
            e,
            stack,
          );
          imageUploadError = 'Image upload failed: ${e.toString()}';
        } finally {
          // Ensure temporary compressed file is deleted, regardless of upload success/failure
          if (tempCompressedFile != null &&
              tempCompressedFile.path != profileImageFile.path) {
            try {
              await tempCompressedFile.delete();
              _logger.info(
                'Deleted compressed temporary file: ${tempCompressedFile.path}',
              );
            } catch (e) {
              _logger.warning('Could not delete compressed temporary file: $e');
            }
          }
        }
      }

      // 5. Call the database repository method
      // This method is now expected to atomically update the profile
      // and return the photo URL that was in the database *before* this update.
      // - If photoUrlToStoreInDb is null (no new image/upload failed), the repository's
      //   updateUserProfile method should NOT change the 'photoUrl' field in the database.
      // - If photoUrlToStoreInDb is a non-null string, the repository's updateUserProfile
      //   method SHOULD update the 'photoUrl' field.
      // In both cases, it returns the 'photoUrl' that was present before the transaction began.
      String? photoUrlFromDbBeforeUpdate;

      _logger.info(
        'Calling updateUserProfile for user $userId with name: $displayName and photoUrl: ${photoUrlToStoreInDb ?? "(no change)"}',
      );
      photoUrlFromDbBeforeUpdate = await dbRepository.updateUserProfile(
        userId: userId, // Use the extracted userId
        displayName: displayName,
        photoUrl:
            photoUrlToStoreInDb, // Pass new URL if uploaded, else null (assumed no-change by repo)
      );
      _logger.info(
        'Profile update successful in repository for user $userId. Old photo URL was: $photoUrlFromDbBeforeUpdate',
      );

      // 6. Invalidate the provider that loads the *full* user model from the DB
      //    This ensures that UIs watching currentUserModelProvider get the updated data.
      ref.invalidate(
        currentUserModelProvider,
      ); // Revert to currentUserModelProvider
      _logger.fine('Invalidated currentUserModelProvider.');

      // 6.5. Delete old image from storage if a new one was successfully uploaded and stored in DB.
      // This happens *after* the database has been successfully updated with the new URL.
      if (uploadedPhotoUrl != null && imageUploadError == null) {
        // A new image was successfully uploaded
        if (photoUrlFromDbBeforeUpdate != null &&
            photoUrlFromDbBeforeUpdate.isNotEmpty &&
            photoUrlFromDbBeforeUpdate != uploadedPhotoUrl) {
          // And there was an old one (returned by the transactional update), different from the new one

          // CRITICAL CHECK: Re-fetch the LATEST user data to see what the CURRENT photoUrl is NOW.
          // This helps prevent deleting an image if another rapid update set it back.
          AppUser? latestUserDataAfterUpdate;
          String? currentLivePhotoUrlInDb;
          bool canProceedWithDeletionLogic = true;

          try {
            latestUserDataAfterUpdate = await dbRepository.getUser(userId);
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
              // Proceed with deletion as photoUrlFromDbBeforeUpdate is confirmed not to be the current live one.
              try {
                _logger.info(
                  'Attempting to delete old profile image (obtained from DB pre-update, and confirmed not current live): $photoUrlFromDbBeforeUpdate',
                );
                final oldImageRef = storageRepository.storageInstance
                    .refFromURL(photoUrlFromDbBeforeUpdate);
                await oldImageRef.delete();
                _logger.info(
                  'Old profile image (obtained from DB pre-update) deleted successfully: $photoUrlFromDbBeforeUpdate',
                );
              } catch (e, stack) {
                // Log error but don't let it fail the whole profile update operation
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

      // 7. Set state to success
      // If an imageUploadError occurred, the overall state reflects this error,
      // even if other parts (like display name update) succeeded.
      if (imageUploadError != null) {
        state = AsyncError(Exception(imageUploadError), StackTrace.current);
      } else {
        state = const AsyncData(null);
      }
      _logger.info('Profile update state set to success.');
    } catch (e, stack) {
      // 8. Set state to error
      // Try to get userId again for logging, might still be null
      final userIdForLog =
          ref.read(currentUserProvider).valueOrNull?.uid ?? 'unknown';
      _logger.severe(
        'Failed to update profile for user $userIdForLog',
        e,
        stack,
      );
      state = AsyncError(e, stack);
    }
  }
}
