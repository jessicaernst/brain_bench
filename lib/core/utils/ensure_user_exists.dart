import 'dart:io' show Platform;
import 'package:brain_bench/core/native_channels/contact_channel.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:logging/logging.dart';

final _logger = Logger('EnsureUser');

/// Ensures that a user corresponding to the authenticated AppUser exists in the
/// application's database.
/// ... (rest of the doc comment) ...
/// **iOS Specific Enhancement:** On iOS devices, it attempts to fetch the user's
/// contact name and image (Base64) from the device's contacts. If a name is found
/// and the user has no display name, it's used. The image handling is deferred.
Future<void> ensureUserExistsIfNeeded(Ref ref, model.AppUser? appUser) async {
  // Ensure the AppUser object (mapped from Auth provider) is not null.
  if (appUser == null) {
    _logger.warning(
        'ensureUserExistsIfNeeded called with null appUser. Skipping.');
    return;
  }

  DeviceContactInfo? deviceContactInfo;
  // --- iOS Specific: Attempt to fetch contact info ---
  if (Platform.isIOS) {
    _logger.info('Platform is iOS. Attempting to fetch device contact info...');
    try {
      // Call the native channel to get contact details
      deviceContactInfo = await ContactChannel.getUserContactFromDevice();
      if (deviceContactInfo != null) {
        _logger.info(
            'Successfully fetched device contact info: $deviceContactInfo');
      } else {
        _logger.info(
            'No device contact info found, permission denied, or feature not available.');
      }
    } catch (e, st) {
      // Log errors from the channel call but don't let it block the user sync process.
      _logger.warning('Error fetching device contact info: $e', e, st);
    }
  }
  // --- End of iOS Specific Fetch ---

  try {
    // Get the database repository instance.
    final db = await ref.read(quizMockDatabaseRepositoryProvider.future);
    // Check if the user already exists in the local database.
    final existingDbUser = await db.getUser(appUser.uid);

    if (existingDbUser == null) {
      // --- User does NOT exist in the DB -> Create ---
      _logger
          .info('User ${appUser.uid} not found in DB. Creating new entry...');

      // Start with data from the authentication provider
      String? finalDisplayName = appUser.displayName;
      final String? finalPhotoUrl =
          appUser.photoUrl; // Keep original URL for now

      // --- TODO (Post-Firestore Migration & Security Setup) ---
      // Description: Upload the profile image from device contacts (iOS only)
      //              to Firebase Storage if no photoUrl exists from the auth provider.
      // Steps:
      // 1. Check if Platform.isIOS and deviceContactInfo?.imageBase64 is valid.
      // 2. Check if finalPhotoUrl is null or empty.
      // 3. If both conditions are true:
      //    a. Get the StorageRepository instance: `ref.read(storageRepositoryProvider)`.
      //    b. Call `storageRepo.uploadProfileImageBase64(appUser.uid, deviceContactInfo!.imageBase64!)`.
      //    c. Assign the returned download URL to `finalPhotoUrl`.
      //    d. Handle potential errors during upload gracefully (e.g., log warning, proceed without image).
      // Requires: Firestore setup, Security Rules, App Check, StorageRepository implementation.

      // --- Use device contact name ONLY if auth provider didn't supply one ---
      if (Platform.isIOS && // Check platform again for safety
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (finalDisplayName == null || finalDisplayName.isEmpty)) {
        finalDisplayName = deviceContactInfo.name;
        _logger.info(
            'Using device contact name "$finalDisplayName" for new user ${appUser.uid} as auth provider name was missing.');
      }

      // Create the new user object using potentially updated details.
      final newUser = appUser.copyWith(
        displayName: finalDisplayName,
        photoUrl:
            finalPhotoUrl, // Use original URL or potentially updated one from todo above
        // Initialize other fields with defaults from the model or empty maps.
        categoryProgress: {},
        isTopicDone: {},
        // themeMode and language should use @Default from the model.
      );

      await db.saveUser(newUser);
      _logger.info('🆕 Successfully created user ${appUser.uid} in DB.');
    } else {
      // --- User DOES exist in the DB -> Check for updates ---
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');
      final Map<String, dynamic> updates = {};
      bool needsUpdate = false;

      // 1. Check displayName: Prioritize update from Auth Provider if different from DB.
      if (appUser.displayName != null &&
          appUser.displayName!.isNotEmpty &&
          appUser.displayName != existingDbUser.displayName) {
        updates['displayName'] = appUser.displayName;
        needsUpdate = true;
        _logger.fine(
            'Detected displayName update for ${appUser.uid} from Auth Provider.');
      }

      // 2. Check photoUrl: Prioritize update from Auth Provider if different from DB.
      if (appUser.photoUrl != null &&
          appUser.photoUrl != existingDbUser.photoUrl) {
        updates['photoUrl'] = appUser.photoUrl;
        needsUpdate = true;
        _logger.fine(
            'Detected photoUrl update for ${appUser.uid} from Auth Provider.');
      }

      // --- TODO (Post-Firestore Migration & Security Setup) ---
      // Description: Upload the profile image from device contacts (iOS only)
      //              to Firebase Storage if no photoUrl exists after considering
      //              the auth provider's update.
      // Steps:
      // 1. Determine the current effective photo URL:
      //    `final currentPhotoUrl = updates['photoUrl'] ?? existingDbUser.photoUrl;`
      // 2. Check if Platform.isIOS and deviceContactInfo?.imageBase64 is valid.
      // 3. Check if currentPhotoUrl is null or empty.
      // 4. If conditions 2 and 3 are true:
      //    a. Get the StorageRepository instance: `ref.read(storageRepositoryProvider)`.
      //    b. Call `storageRepo.uploadProfileImageBase64(appUser.uid, deviceContactInfo!.imageBase64!)`.
      //    c. If upload is successful, set `updates['photoUrl'] = newUrl` and `needsUpdate = true`.
      //    d. Handle potential errors during upload gracefully.
      // Requires: Firestore setup, Security Rules, App Check, StorageRepository implementation.

      // 3. Check displayName from Device Contact (iOS only):
      //    Use it ONLY if the current name (considering potential update from step 1) is still null or empty.
      final currentDisplayName =
          updates['displayName'] ?? existingDbUser.displayName;
      if (Platform.isIOS && // Check platform again
          deviceContactInfo?.name != null &&
          deviceContactInfo!.name!.isNotEmpty &&
          (currentDisplayName == null || currentDisplayName.isEmpty)) {
        // Only update if the device contact provides a name and we don't have one yet.
        updates['displayName'] = deviceContactInfo.name;
        needsUpdate = true;
        _logger.info(
            'Updating displayName for ${appUser.uid} using device contact name "${deviceContactInfo.name}" as current name was missing.');
      }

      // Apply updates if any were detected.
      if (needsUpdate) {
        _logger.info(
            'Updating user ${appUser.uid} in DB with changes: ${updates.keys.join(', ')}');
        // Create the updated user object using copyWith on the existing DB user.
        final updatedUser = existingDbUser.copyWith(
          // Apply only the detected updates.
          displayName:
              updates['displayName'], // Let copyWith handle null vs value
          photoUrl: updates['photoUrl'], // Let copyWith handle null vs value
          // Other fields are retained from existingDbUser.
        );
        await db.saveUser(updatedUser);
        _logger.info('✅ Successfully updated user ${appUser.uid} in DB.');
      } else {
        _logger.fine('✅ User ${appUser.uid} is already up-to-date in DB.');
      }
    }
  } catch (e, st) {
    _logger.severe(
        'Error during DB interaction in ensureUserExistsIfNeeded for ${appUser.uid}: $e',
        e,
        st);
    // Consider rethrowing or specific error handling if DB sync is critical.
  }
}
