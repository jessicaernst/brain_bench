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

  // Use the user repository
  try {
    final userRepository = read(userFirebaseRepositoryProvider);
    final existingDbUser = await userRepository.getUser(appUser.uid);

    if (existingDbUser == null) {
      _logger.info(
        'User ${appUser.uid} not found in DB. Creating new entry...',
      );

      // Initialize finalDisplayName and finalPhotoUrl before potentially using them
      String? finalDisplayName = appUser.displayName;
      final String? finalPhotoUrl = appUser.photoUrl;

      // Determine finalDisplayName, potentially using contact name as fallback
      if (Platform.isIOS &&
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (finalDisplayName == null || finalDisplayName.isEmpty)) {
        finalDisplayName = deviceContactInfo.name;
        _logger.info(
          'Using device contact name "$finalDisplayName" for new user ${appUser.uid} as auth provider name was missing.',
        );
      }

      // Create the initial user object (without contact image URL yet, if auto-save happens later)
      final newUser = appUser.copyWith(
        displayName: finalDisplayName,
        photoUrl: finalPhotoUrl,
        categoryProgress: {},
        isTopicDone: {},
      );

      // Save the initial user entry to the database
      await userRepository.saveUser(newUser);
      _logger.info(
        '🆕 Successfully created initial user ${appUser.uid} in DB.',
      );

      // --- Now handle contact image for NEW user if found ---
      if (deviceContactInfo?.imageBase64 != null &&
          (appUser.photoUrl == null || appUser.photoUrl!.isEmpty)) {
        _logger.info(
          'New user created. Attempting to process and save contact image.',
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
            'EnsureUser: Set provisional profile image from contact: ${tempFile.path}',
          );

          await read(profileNotifierProvider.notifier).updateUserProfileImage(
            newImageFile: contactXFile,
            userId: appUser.uid,
          );
          _logger.info('EnsureUser: Contact image auto-save successful.');
          read(provisionalProfileImageProvider.notifier).clearImage();

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
        // User has Auth photoUrl, no contact image needed
        _logger.info(
          'New user has Firebase Auth photoUrl. Clearing any provisional image.',
        );
        read(provisionalProfileImageProvider.notifier).clearImage();
      }

      return true; // User was created
    } else {
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');
      // --- Handle contact image for EXISTING user ---
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

      // Check photoUrl from Auth provider for updates
      // Auto-saved photoUrl is handled by ProfileNotifier updating the DB directly.
      // We only need to check if the Auth provider photoUrl has changed.
      if (appUser.photoUrl !=
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
