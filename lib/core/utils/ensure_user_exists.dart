import 'dart:io' show Platform;

import 'package:brain_bench/core/native_channels/contact_channel.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

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
    _logger.info('Platform is iOS. Attempting to fetch device contact info...');
    try {
      deviceContactInfo = await ContactChannel.getUserContactFromDevice();
      if (deviceContactInfo != null) {
        _logger.info(
          'Successfully fetched device contact info: $deviceContactInfo',
        );
      } else {
        _logger.info(
          'No device contact info found, permission denied, or feature not available.',
        );
      }
    } catch (e, st) {
      _logger.warning('Error fetching device contact info: $e', e, st);
    }
  }

  try {
    final db = await read(quizMockDatabaseRepositoryProvider.future);
    final existingDbUser = await db.getUser(appUser.uid);

    if (existingDbUser == null) {
      _logger.info(
        'User ${appUser.uid} not found in DB. Creating new entry...',
      );

      String? finalDisplayName = appUser.displayName;
      final String? finalPhotoUrl = appUser.photoUrl;

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

      await db.saveUser(newUser);
      _logger.info('🆕 Successfully created user ${appUser.uid} in DB.');
      return true;
    } else {
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');
      final Map<String, dynamic> updates = {};
      bool needsUpdate = false;

      if (appUser.displayName != null &&
          appUser.displayName!.isNotEmpty &&
          appUser.displayName != existingDbUser.displayName) {
        updates['displayName'] = appUser.displayName;
        needsUpdate = true;
        _logger.fine(
          'Detected displayName update for ${appUser.uid} from Auth Provider.',
        );
      }

      if (appUser.photoUrl != null &&
          appUser.photoUrl != existingDbUser.photoUrl) {
        updates['photoUrl'] = appUser.photoUrl;
        needsUpdate = true;
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
        final updatedUser = existingDbUser.copyWith(
          displayName: updates['displayName'],
          photoUrl: updates['photoUrl'],
        );
        await db.saveUser(updatedUser);
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

var ensureUserExistsIfNeeded = _ensureUserExistsIfNeededImpl;
