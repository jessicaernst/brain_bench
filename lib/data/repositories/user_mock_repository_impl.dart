import 'dart:convert';
import 'dart:io';

import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('UserMockRepository');

/// A mock implementation of the [UserRepository] interface.
///
/// This class simulates a user data repository by reading and writing data
/// to a local JSON file (`user.json`). It is intended for development and
/// testing purposes and should not be used in a production environment.
class UserMockRepositoryImpl implements UserRepository {
  UserMockRepositoryImpl({required this.userPath});

  /// The file path for the user data (`user.json`).
  final String userPath;

  /// Retrieves an [AppUser] object for a given user ID from the mock database.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to retrieve.
  ///
  /// Returns:
  ///   A [Future] that completes with an [AppUser] object, or null if not found.
  ///   Returns null if an error occurs or the file does not exist.
  @override
  Future<AppUser?> getUser(String userId) async {
    try {
      final file = File(userPath);
      if (!await file.exists()) {
        _logger.fine('User file not found at $userPath.');
        return null;
      }

      final jsonString = await file.readAsString();
      // Handle empty file content
      if (jsonString.isEmpty) {
        _logger.fine('User file is empty at $userPath.');
        return null;
      }

      final jsonMap = json.decode(jsonString);
      final List users = jsonMap['users'] ?? [];

      final userList =
          users
              .map((e) => AppUser.fromJson(e))
              .where((u) => u.uid == userId)
              .toList();

      _logger.fine(
        'getUser for $userId: Found ${userList.length} users. Returning ${userList.isNotEmpty ? userList.first.uid : 'null'}',
      );

      return userList.isNotEmpty ? userList.first : null;
    } catch (e, stack) {
      _logger.severe('Error in getUser for $userId: $e', e, stack);
      return null;
    }
  }

  /// Saves an [AppUser] object to the mock database.
  ///
  /// Typically used for creating a new user entry.
  ///
  /// Parameters:
  ///   - [user]: The [AppUser] object to save.
  ///
  /// Returns:
  ///   A [Future] that completes when the user has been saved.
  ///   Logs an error if an exception occurs.
  @override
  Future<void> saveUser(AppUser user) async {
    try {
      final file = File(userPath);
      Map<String, dynamic> jsonMap = {'users': []};

      if (file.existsSync()) {
        final content = await file.readAsString();
        // Handle empty file content
        if (content.isNotEmpty) {
          jsonMap = json.decode(content);
        }
        jsonMap['users'] ??= []; // Ensure 'users' list exists
      }

      (jsonMap['users'] as List).add(user.toJson());

      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('🆕 User saved: ${user.uid}');
    } catch (e, stack) {
      _logger.severe('Error in saveUser for ${user.uid}: $e', e, stack);
    }
  }

  /// Updates an existing [AppUser] object in the mock database.
  ///
  /// This method replaces the existing user entry with the provided updated user object.
  ///
  /// Parameters:
  ///   - [user]: The [AppUser] object with updated information.
  ///
  /// Returns:
  ///   A [Future] that completes when the user has been updated.
  ///   Logs a warning if the user is not found.
  @override
  Future<void> updateUser(AppUser user) async {
    try {
      final file = File(userPath);
      if (!file.existsSync()) {
        _logger.warning('User file not found at $userPath for update.');
        return;
      }

      final jsonString = await file.readAsString();
      // Handle empty file content
      if (jsonString.isEmpty) {
        _logger.warning('User file is empty at $userPath for update.');
        return;
      }

      final jsonMap = json.decode(jsonString);
      final List<dynamic> users = jsonMap['users'] ?? [];

      final index = users.indexWhere((e) => e is Map && e['uid'] == user.uid);
      if (index == -1) {
        _logger.warning('User not found for update: ${user.uid}');
        return;
      }

      users[index] = user.toJson(); // Replace the old entry with the new one
      jsonMap['users'] = users; // Ensure the list is assigned back

      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('✅ User updated: ${user.uid}');
    } catch (e, stack) {
      _logger.severe('Error in updateUser for ${user.uid}: $e', e, stack);
    }
  }

  /// Updates specific profile details for a user in the mock database.
  ///
  /// This method updates only the provided fields ([displayName], [photoUrl])
  /// for the user with the given [userId].
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to update.
  ///   - [displayName]: The new display name for the user (optional).
  ///   - [photoUrl]: The new photo URL for the user (optional).
  ///                 Passing null means the photoUrl is not changed.
  ///
  /// Returns:
  ///   A [Future] that completes when the profile has been updated.
  ///   Logs a warning if the user is not found.
  @override
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final file = File(userPath);
      if (!await file.exists()) {
        _logger.warning('User file not found at $userPath for profile update.');
        return;
      }

      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        _logger.warning('User file is empty at $userPath for profile update.');
        return;
      }
      final jsonMap = json.decode(jsonString);
      final List<dynamic> users = jsonMap['users'] ?? [];

      final index = users.indexWhere((e) => e is Map && e['uid'] == userId);
      if (index == -1) {
        _logger.warning('User $userId not found for profile update.');
        return;
      }

      final Map<String, dynamic> existingUserMap = Map<String, dynamic>.from(
        users[index],
      );
      final Map<String, dynamic> updatedUserMap = {...existingUserMap};

      if (displayName != null) updatedUserMap['displayName'] = displayName;
      if (photoUrl != null) updatedUserMap['photoUrl'] = photoUrl;

      users[index] = updatedUserMap;
      jsonMap['users'] = users;

      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('✅ Profile updated for user $userId.');
    } catch (e, stack) {
      _logger.severe('Error updating profile for $userId: $e', e, stack);
    }
  }

  /// Deletes an [AppUser] object for a given user ID from the mock database.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to delete.
  ///
  /// Returns:
  ///   A [Future] that completes when the user has been deleted.
  ///   Logs a warning if the user is not found.
  @override
  Future<void> deleteUser(String userId) async {
    try {
      final file = File(userPath);
      if (!file.existsSync()) {
        _logger.warning('User file not found at $userPath for deletion.');
        return;
      }

      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        _logger.warning('User file is empty at $userPath for deletion.');
        return;
      }
      final jsonMap = json.decode(jsonString);
      final List<dynamic> users = jsonMap['users'] ?? [];

      final updatedUsers =
          users.where((e) => e is Map && e['uid'] != userId).toList();

      if (updatedUsers.length == users.length) {
        _logger.warning('User $userId not found for deletion.');
        return;
      }

      jsonMap['users'] = updatedUsers;
      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('🗑️ User deleted: $userId');
    } catch (e, stack) {
      _logger.severe('Error in deleteUser for $userId: $e', e, stack);
    }
  }

  @override
  Future<void> updateUserFields(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final file = File(userPath);
      if (!await file.exists()) {
        _logger.warning('User file not found at $userPath for field update.');
        return;
      }

      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        _logger.warning('User file is empty at $userPath for field update.');
        return;
      }
      final jsonMap = json.decode(jsonString);
      final List<dynamic> users = jsonMap['users'] ?? [];

      final index = users.indexWhere((e) => e is Map && e['uid'] == userId);
      if (index == -1) {
        _logger.warning('User $userId not found for field update.');
        return;
      }

      // Get the existing user data as a Map
      final Map<String, dynamic> existingUserMap = Map<String, dynamic>.from(
        users[index],
      );
      // Merge the new data with the existing data. New data overwrites existing keys.
      final Map<String, dynamic> updatedUserMap = {...existingUserMap, ...data};

      users[index] = updatedUserMap;
      jsonMap['users'] = users;
      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info(
        '✅ Fields updated for user $userId: ${data.keys.join(', ')}',
      );
    } catch (e, stack) {
      _logger.severe('Error updating fields for $userId: $e', e, stack);
    }
  }
}
