import 'dart:convert';
import 'dart:typed_data';

import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
import 'package:brain_bench/core/native_channels/contact_channel.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('EnsureUser');

typedef Reader = T Function<T>(ProviderListenable<T>);

Future<bool> _ensureUserExistsIfNeededImpl(
  Reader read,
  model.AppUser? appUser,
) async {
  if (appUser == null) {
    _logger.warning(
      'ensureUserExistsIfNeeded called with null appUser. Skipping.',
    );
    return false;
  }

  DeviceContactInfo? deviceContactInfo;
  if (P.isIOS) {
    final bool isApplePrivateRelay = appUser.email.endsWith(
      '@privaterelay.appleid.com',
    );

    if (!isApplePrivateRelay) {
      _logger.info('iOS: fetching device contact for ${appUser.email}');
      try {
        deviceContactInfo = await ContactChannel.getUserContactFromDevice(
          userEmail: appUser.email,
        );
        if (deviceContactInfo != null) {
          _logger.info('Fetched device contact info: $deviceContactInfo');
        }
      } catch (e, st) {
        _logger.warning('Error fetching device contact: $e', e, st);
      }
    } else {
      _logger.info(
        'Apple private relay email detected; skipping device contact fetch.',
      );
    }
  }

  try {
    final userRepository = read(userFirebaseRepositoryProvider);
    final existingDbUser = await userRepository.getUser(appUser.uid);

    if (existingDbUser == null) {
      _logger.info(
        'User ${appUser.uid} not found in DB. Creating new entry...',
      );

      String? finalDisplayName = appUser.displayName;
      final String? finalPhotoUrl = appUser.photoUrl;

      if (P.isIOS &&
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (finalDisplayName == null || finalDisplayName.isEmpty)) {
        finalDisplayName = deviceContactInfo.name;
        _logger.info(
          'Using device contact name "$finalDisplayName" for new user ${appUser.uid}.',
        );
      }

      final newUser = appUser.copyWith(
        displayName: finalDisplayName,
        photoUrl: finalPhotoUrl,
        categoryProgress: {},
        isTopicDone: {},
      );

      await userRepository.saveUser(newUser);
      _logger.info('Created initial user ${appUser.uid} in DB.');

      // contact image for NEW user
      if (deviceContactInfo?.imageBase64 != null &&
          (appUser.photoUrl == null || appUser.photoUrl!.isEmpty)) {
        _logger.info('Processing contact image for new user.');
        try {
          final Uint8List imageBytes = base64Decode(
            deviceContactInfo!.imageBase64!,
          );

          // ✅ web-safe: create an XFile from bytes (no File/IO)
          final contactXFile = XFile.fromData(
            imageBytes,
            name: 'contact_image_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          );

          read(provisionalProfileImageProvider.notifier).setImage(contactXFile);
          _logger.info('Set provisional profile image from contact (bytes).');

          await read(profileNotifierProvider.notifier).updateUserProfileImage(
            newImageFile: contactXFile,
            userId: appUser.uid,
          );
          _logger.info('Contact image auto-save successful.');
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
        _logger.info(
          'New user has Auth photoUrl. Clearing any provisional image.',
        );
        read(provisionalProfileImageProvider.notifier).clearImage();
      }

      return true;
    } else {
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');

      // contact image for EXISTING user
      if (deviceContactInfo?.imageBase64 != null) {
        final bool hasDbPhoto =
            (existingDbUser.photoUrl != null &&
                existingDbUser.photoUrl!.isNotEmpty);
        final bool hasAuthPhoto =
            (appUser.photoUrl != null && appUser.photoUrl!.isNotEmpty);

        if (!hasDbPhoto && !hasAuthPhoto) {
          _logger.info(
            'Existing user without photo; attempting contact image.',
          );
          try {
            final Uint8List imageBytes = base64Decode(
              deviceContactInfo!.imageBase64!,
            );

            final contactXFile = XFile.fromData(
              imageBytes,
              name:
                  'contact_image_${DateTime.now().millisecondsSinceEpoch}.png',
              mimeType: 'image/png',
            );

            read(
              provisionalProfileImageProvider.notifier,
            ).setImage(contactXFile);
            _logger.info(
              'Set provisional contact image for existing user (bytes).',
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

      final Map<String, dynamic> updates = {};
      bool needsUpdate = false;

      if (appUser.displayName != null &&
          appUser.displayName!.isNotEmpty &&
          appUser.displayName != existingDbUser.displayName) {
        updates['displayName'] = appUser.displayName;
        needsUpdate = true;
        _logger.fine('Detected displayName update for ${appUser.uid}.');
      }

      if (appUser.photoUrl != null &&
          appUser.photoUrl!.isNotEmpty &&
          appUser.photoUrl != existingDbUser.photoUrl) {
        updates['photoUrl'] = appUser.photoUrl;
        needsUpdate = true;
        read(provisionalProfileImageProvider.notifier).clearImage();
        _logger.fine('Detected photoUrl update for ${appUser.uid}.');
      }

      final currentDisplayName =
          updates['displayName'] ?? existingDbUser.displayName;
      if (P.isIOS &&
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (currentDisplayName == null || currentDisplayName.isEmpty)) {
        updates['displayName'] = deviceContactInfo.name;
        needsUpdate = true;
        _logger.info(
          'Updating displayName for ${appUser.uid} from device contact name.',
        );
      }

      if (needsUpdate) {
        _logger.info(
          'Updating user ${appUser.uid} in DB with: ${updates.keys.join(', ')}',
        );
        await userRepository.updateUserFields(appUser.uid, updates);
        _logger.info('Updated user ${appUser.uid} in DB.');
      } else {
        _logger.fine('User ${appUser.uid} is up-to-date.');
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

Future<bool> ensureUserExistsIfNeeded(
  Reader read,
  model.AppUser? appUser,
) async {
  final prefs = await SharedPreferences.getInstance();
  final snackbarShownKey = 'contactImageSnackbarShown_${appUser?.uid}';
  if (prefs.getBool(snackbarShownKey) == null) {
    await prefs.setBool(snackbarShownKey, false);
  }
  return _ensureUserExistsIfNeededImpl(read, appUser);
}
