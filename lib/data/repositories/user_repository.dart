import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';

/// An abstract class defining the contract for a user data repository.
///
/// This interface specifies the methods that any concrete implementation of a
/// user data repository must provide. It includes methods for retrieving,
/// saving, updating, and deleting user information, as well as for specific
/// profile updates.
abstract class UserRepository {
  /// Retrieves an [AppUser] object for a given user ID.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to retrieve.
  ///
  /// Returns:
  ///   A [Future] that completes with an [AppUser] object, or null if not found.
  Future<AppUser?> getUser(String userId);

  /// Saves an [AppUser] object.
  ///
  /// Typically used for creating a new user entry.
  ///
  /// Parameters:
  ///   - [user]: The [AppUser] object to save.
  Future<void> saveUser(AppUser user);

  /// Updates an existing [AppUser] object.
  ///
  /// This method might be used for more comprehensive updates to the user object.
  /// For specific profile field updates, consider [updateUserProfile].
  ///
  /// Parameters:
  ///   - [user]: The [AppUser] object with updated information.
  Future<void> updateUser(AppUser user);

  /// Updates specific fields of an existing user based on a map of changes.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to update.
  ///   - [data]: A map containing the fields and their new values to update.
  ///             Keys should match the field names in the user model.
  Future<void> updateUserFields(String userId, Map<String, dynamic> data);

  /// Updates specific profile details for a user.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to update.
  ///   - [displayName]: The new display name for the user (optional).
  ///   - [photoUrl]: The new photo URL for the user (optional).
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  });

  /// Deletes an [AppUser] object for a given user ID.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to delete.
  Future<void> deleteUser(String userId);

  /// Marks a topic as done for a specific user and updates their progress.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user.
  ///   - [topicId]: The ID of the topic to mark as done.
  ///   - [categoryId]: The ID of the category the topic belongs to.
  ///   - [topicsForCategory]: List of all topics in that category to calculate progress.
  Future<void> markTopicAsDone({
    required String userId,
    required String topicId,
    required String categoryId,
    required List<Topic> topicsForCategory,
  });
}
