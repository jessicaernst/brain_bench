import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Use an alias for clarity, especially if Firebase User might also be imported elsewhere
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:logging/logging.dart';

final _logger = Logger('EnsureUser');

/// Ensures that a user corresponding to the authenticated AppUser exists in the
/// application's database (managed by QuizMockDatabaseRepository).
///
/// This function is typically called after a successful authentication flow.
///
/// If the user doesn't exist in the local DB, it creates a new record using details
/// from the authenticated [appUser] (which contains data mapped from Firebase Auth)
/// and initializes other app-specific fields using defaults defined in the model.
///
/// If the user already exists, it checks if `displayName` or `photoUrl` from the
/// authenticated [appUser] are newer or different from the data in the local DB
/// and updates the local record accordingly.
Future<void> ensureUserExistsIfNeeded(Ref ref, model.AppUser? appUser) async {
  // Ensure the AppUser object (mapped from Firebase Auth) is not null.
  if (appUser == null) {
    _logger.warning(
        'ensureUserExistsIfNeeded called with null appUser. Skipping.');
    return;
  }

  try {
    // Added try-catch to handle potential DB errors gracefully
    // Get the database repository instance.
    final db = await ref.read(quizMockDatabaseRepositoryProvider.future);
    // Check if the user already exists in the local database.
    final existingDbUser = await db.getUser(appUser.uid);

    if (existingDbUser == null) {
      // --- User does NOT exist in the DB -> Create ---
      _logger
          .info('User ${appUser.uid} not found in DB. Creating new entry...');

      // Create a new user based on the mapped appUser from Firebase Auth.
      // copyWith takes uid, email, displayName, photoUrl from the incoming appUser.
      final newUser = appUser.copyWith(
        // Explicitly set empty maps to ensure initialization,
        // although @Default in the model should handle this.
        categoryProgress: {},
        isTopicDone: {},
        // profileImageUrl will be null by default as it's not in the incoming appUser.
        // themeMode and language should be handled by @Default in the AppUser model.
        // No quizAttempts field in the model.
      );

      // Assumes saveUser handles creation if the user doesn't exist.
      await db.saveUser(newUser);
      _logger.info('🆕 Successfully created user ${appUser.uid} in DB.');
    } else {
      // --- User DOES exist in the DB -> Check for updates ---
      _logger.fine('User ${appUser.uid} found in DB. Checking for updates...');
      // Map to hold potential updates.
      final Map<String, dynamic> updates = {};
      // Flag to track if an update is necessary.
      bool needsUpdate = false;

      // Check displayName: Update if Firebase provided one and it differs from the DB value.
      if (appUser.displayName != null &&
          appUser.displayName != existingDbUser.displayName) {
        updates['displayName'] = appUser.displayName;
        needsUpdate = true;
        _logger.fine('Detected displayName update for ${appUser.uid}.');
      }

      // Check photoUrl: Update if Firebase provided one and it differs from the DB value.
      if (appUser.photoUrl != null &&
          appUser.photoUrl != existingDbUser.photoUrl) {
        updates['photoUrl'] = appUser.photoUrl;
        needsUpdate = true;
        _logger.fine('Detected photoUrl update for ${appUser.uid}.');
      }

      if (needsUpdate) {
        _logger.info('Updating user ${appUser.uid} in DB...');
        // Create the updated user object using copyWith on the existing DB user.
        final updatedUser = existingDbUser.copyWith(
          // Apply only the detected updates.
          displayName: updates['displayName'] ?? existingDbUser.displayName,
          photoUrl: updates['photoUrl'] ?? existingDbUser.photoUrl,
          // Other fields (themeMode, language, progress, etc.) are retained from existingDbUser.
        );
        // Assumes saveUser handles updates if the user exists.
        await db.saveUser(updatedUser);
        _logger.info('✅ Successfully updated user ${appUser.uid} in DB.');
      } else {
        _logger.fine('✅ User ${appUser.uid} is already up-to-date in DB.');
      }
    }
  } catch (e, st) {
    _logger.severe(
        'Error in ensureUserExistsIfNeeded for ${appUser.uid}: $e', e, st);
    // Consider rethrowing or specific error handling if DB sync is critical.
  }
}
