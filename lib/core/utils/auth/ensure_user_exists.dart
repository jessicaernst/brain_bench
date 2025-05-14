import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
import 'package:brain_bench/core/native_channels/contact_channel.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('EnsureUser');

typedef Reader = T Function<T>(ProviderListenable<T>);

Future<bool> _ensureUserExistsIfNeededImpl(
  Reader read,
  model.AppUser? appUser,
) async {
  // Return bool
  if (appUser == null) {
    _logger.warning(
      'ensureUserExistsIfNeeded called with null appUser. Skipping.',
    );
    return false;
  }

  DeviceContactInfo? deviceContactInfo;
  if (Platform.isIOS) {
    // Check if the email is an Apple private relay address
    final bool isApplePrivateRelay = appUser.email.endsWith(
      '@privaterelay.appleid.com',
    );

    if (isApplePrivateRelay) {
      _logger.info(
        'User is using an Apple private relay email. Skipping device contact fetch for image/name prefill.',
      );
      // deviceContactInfo remains null, so no contact image/name will be used from device.
    } else {
      _logger.info(
        'Platform is iOS. Attempting to fetch device contact info by email: ${appUser.email}',
      );
      try {
        deviceContactInfo = await ContactChannel.getUserContactFromDevice(
          userEmail: appUser.email,
        );
        if (deviceContactInfo != null) {
          _logger.info(
            'Successfully fetched device contact info: $deviceContactInfo',
          );
        } else {
          _logger.info(
            'No device contact info found for email ${appUser.email}, or permission denied.',
          );
        }
      } catch (e, st) {
        _logger.warning(
          'Error fetching device contact info by email ${appUser.email}: $e',
          e,
          st,
        );
      }
    }
  }

  try {
    final userRepository = await read(
      userRepositoryProvider.future,
    ); // Use the new user repository
    final existingDbUser = await userRepository.getUser(appUser.uid);

    if (existingDbUser == null) {
      _logger.info(
        'User ${appUser.uid} not found in DB. Creating new entry...',
      );

      // --- Handle contact image for NEW user ---
      String? photoUrlFromAutoSave;
      if (deviceContactInfo?.imageBase64 != null &&
          (appUser.photoUrl == null || appUser.photoUrl!.isEmpty)) {
        _logger.info(
          'New user and no Firebase Auth photoUrl. Attempting to use contact image.',
        );
        try {
          final imageBytes = base64Decode(deviceContactInfo!.imageBase64!);
          final tempDir = await getTemporaryDirectory();
          final tempFilePath =
              '${tempDir.path}/contact_image_ensure_user_${DateTime.now().millisecondsSinceEpoch}.png';
          final tempFile = File(tempFilePath);
          await tempFile.writeAsBytes(imageBytes);
          final contactXFile = XFile(tempFile.path);

          read(provisionalProfileImageProvider.notifier).setImage(contactXFile);
          _logger.info(
            'EnsureUser: Set provisional contact image for new user: ${tempFile.path}',
          );

          _logger.info(
            'EnsureUser: Auto-saving contact image to Firebase for new user ${appUser.uid}.',
          );
          // ProfileNotifier.updateUserProfileImage updates the DB directly
          await read(profileNotifierProvider.notifier).updateUserProfileImage(
            newImageFile: contactXFile,
            userId: appUser.uid,
          );
          _logger.info(
            'EnsureUser: Contact image auto-save successful for new user.',
          );
          read(provisionalProfileImageProvider.notifier).clearImage();

          // Attempt to get the newly saved photoUrl
          final userAfterAutoSave = await userRepository.getUser(appUser.uid);
          photoUrlFromAutoSave = userAfterAutoSave?.photoUrl;
          if (photoUrlFromAutoSave != null) {
            _logger.info(
              'Retrieved photoUrl after auto-save: $photoUrlFromAutoSave',
            );
          }

          final prefs = await SharedPreferences.getInstance();
          final snackbarShownKey = 'contactImageSnackbarShown_${appUser.uid}';
          if (!(prefs.getBool(snackbarShownKey) ?? false)) {
            read(showContactImageAutoSaveSnackbarProvider.notifier).trigger();
            await prefs.setBool(snackbarShownKey, true);
            _logger.info('Snackbar signal set for auto-saved contact image.');
          }
        } catch (e, st) {
          _logger.severe(
            'Error processing/saving contact image for new user',
            e,
            st,
          );
        }
      } else if (appUser.photoUrl != null && appUser.photoUrl!.isNotEmpty) {
        _logger.info(
          'New user has Firebase Auth photoUrl. Clearing provisional image.',
        );
        read(provisionalProfileImageProvider.notifier).clearImage();
      }
      // --- End of contact image handling for new user ---

      String? finalDisplayName = appUser.displayName;
      // Prioritize photoUrl from auto-save, then from Auth provider
      final String? finalPhotoUrl = photoUrlFromAutoSave ?? appUser.photoUrl;

      if (Platform.isIOS &&
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (finalDisplayName == null || finalDisplayName.isEmpty)) {
        finalDisplayName = deviceContactInfo.name;
        _logger.info(
          'Using device contact name "$finalDisplayName" for new user ${appUser.uid} as auth provider name was missing.',
        );
      }

      final newUser = appUser.copyWith(
        displayName: finalDisplayName,
        photoUrl: finalPhotoUrl,
        categoryProgress: {},
        isTopicDone: {},
      );
      await userRepository.saveUser(newUser); // Use the new user repository
      _logger.info('🆕 Successfully created user ${appUser.uid} in DB.');
      return true;
    } else {
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');

      // --- Handle contact image for EXISTING user ---
      // Only attempt to auto-save if no photoUrl in existing DB record AND no photoUrl from Auth provider
      String? photoUrlFromAutoSaveForExistingUser;
      if (deviceContactInfo?.imageBase64 != null) {
        if ((existingDbUser.photoUrl == null ||
                existingDbUser.photoUrl!.isEmpty) &&
            (appUser.photoUrl == null || appUser.photoUrl!.isEmpty)) {
          _logger.info(
            'Existing user, no DB/Auth photoUrl. Attempting to use contact image.',
          );
          try {
            final imageBytes = base64Decode(deviceContactInfo!.imageBase64!);
            final tempDir = await getTemporaryDirectory();
            final tempFilePath =
                '${tempDir.path}/contact_image_ensure_user_${DateTime.now().millisecondsSinceEpoch}.png';
            final tempFile = File(tempFilePath);
            await tempFile.writeAsBytes(imageBytes);
            final contactXFile = XFile(tempFile.path);

            read(
              provisionalProfileImageProvider.notifier,
            ).setImage(contactXFile);
            _logger.info(
              'Set provisional contact image for existing user: ${tempFile.path}',
            );

            await read(profileNotifierProvider.notifier).updateUserProfileImage(
              newImageFile: contactXFile,
              userId: appUser.uid,
            );
            _logger.info(
              'Contact image auto-save successful for existing user.',
            );
            read(provisionalProfileImageProvider.notifier).clearImage();

            final userAfterAutoSave = await userRepository.getUser(appUser.uid);
            photoUrlFromAutoSaveForExistingUser = userAfterAutoSave?.photoUrl;

            final prefs = await SharedPreferences.getInstance();
            final snackbarShownKey = 'contactImageSnackbarShown_${appUser.uid}';
            if (!(prefs.getBool(snackbarShownKey) ?? false)) {
              read(showContactImageAutoSaveSnackbarProvider.notifier).trigger();
              await prefs.setBool(snackbarShownKey, true);
              _logger.info(
                'Snackbar signal set for auto-saved contact image (existing user).',
              );
            }
          } catch (e, st) {
            _logger.severe(
              'Error processing/saving contact image for existing user',
              e,
              st,
            );
          }
        } else {
          read(provisionalProfileImageProvider.notifier).clearImage();
        }
      }
      // --- End of contact image handling for existing user ---

      // Use the user repository for updates
      final Map<String, dynamic> updates = {};
      bool needsUpdate = false;

      if (appUser.displayName != null &&
          appUser.displayName!.isNotEmpty &&
          appUser.displayName != existingDbUser.displayName) {
        updates['displayName'] = appUser.displayName;
        needsUpdate = true;
        // If display name from auth provider is now set, clear provisional image if it was based on contact name
        // This specific logic might be too complex here, better to rely on photoUrl check above.
        _logger.fine(
          'Detected displayName update for ${appUser.uid} from Auth Provider.',
        );
      }

      // If contact image was just auto-saved, use that URL for the update map
      if (photoUrlFromAutoSaveForExistingUser != null &&
          photoUrlFromAutoSaveForExistingUser.isNotEmpty) {
        if (photoUrlFromAutoSaveForExistingUser != existingDbUser.photoUrl) {
          updates['photoUrl'] = photoUrlFromAutoSaveForExistingUser;
          needsUpdate = true;
          _logger.fine(
            'Detected photoUrl update for ${appUser.uid} from contact auto-save.',
          );
        }
      } else if (appUser.photoUrl !=
              null && // Otherwise, check photoUrl from Auth provider
          appUser.photoUrl!.isNotEmpty && // Ensure it's not empty
          appUser.photoUrl != existingDbUser.photoUrl) {
        updates['photoUrl'] = appUser.photoUrl;
        needsUpdate = true;
        // If photoUrl from auth provider is now set, clear provisional image
        read(provisionalProfileImageProvider.notifier).clearImage();
        _logger.fine(
          'Detected photoUrl update for ${appUser.uid} from Auth Provider.',
        );
      }

      final currentDisplayName =
          updates['displayName'] ?? existingDbUser.displayName;
      if (Platform.isIOS &&
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (currentDisplayName == null || currentDisplayName.isEmpty)) {
        updates['displayName'] = deviceContactInfo.name;
        needsUpdate = true;
        _logger.info(
          'Updating displayName for ${appUser.uid} using device contact name "${deviceContactInfo.name}" as current name was missing.',
        );
      }

      if (needsUpdate) {
        _logger.info(
          'Updating user ${appUser.uid} in DB with changes: ${updates.keys.join(', ')}',
        );
        // Use the new user repository to update specific fields
        await userRepository.updateUserFields(appUser.uid, updates);
        _logger.info('✅ Successfully updated user ${appUser.uid} in DB.');
      } else {
        _logger.fine('✅ User ${appUser.uid} exists and is up-to-date in DB.');
      }
      return false;
    }
  } catch (e, st) {
    _logger.severe(
      'Error during DB interaction in ensureUserExistsIfNeeded for ${appUser.uid}: $e',
      e,
      st,
    );
    rethrow;
  }
}

/// Ensures that the user exists in the local database and attempts to prefill
/// profile information (name, image) from device contacts if applicable.
/// This function is intended to be called after user authentication.
Future<bool> ensureUserExistsIfNeeded(
  Reader read,
  model.AppUser? appUser,
) async {
  // Initialize SharedPreferences default value for the key if it doesn't exist
  // This helps ensure .getBool never returns null without a default when checked later.
  final prefs = await SharedPreferences.getInstance();
  final snackbarShownKey = 'contactImageSnackbarShown_${appUser?.uid}';
  if (prefs.getBool(snackbarShownKey) == null) {
    await prefs.setBool(snackbarShownKey, false);
  }
  return _ensureUserExistsIfNeededImpl(read, appUser);
}
