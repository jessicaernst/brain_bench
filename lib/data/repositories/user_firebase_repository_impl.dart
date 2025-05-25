import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('UserFirebaseRepository');

class UserFirebaseRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserFirebaseRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<AppUser> get _usersCollection => _firestore
      .collection('users')
      .withConverter<AppUser>(
        fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  @override
  Future<AppUser?> getUser(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      if (docSnapshot.exists) {
        _logger.fine('User found: $userId');
        return docSnapshot.data();
      } else {
        _logger.fine('User not found: $userId');
        return null;
      }
    } catch (e, stack) {
      _logger.severe('Error in getUser for $userId: $e', e, stack);
      return null;
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    try {
      await _usersCollection.doc(user.uid).set(user);
      _logger.info('🆕 User saved: ${user.uid}');
    } catch (e, stack) {
      _logger.severe('Error in saveUser for ${user.uid}: $e', e, stack);
    }
  }

  @override
  Future<void> updateUser(AppUser user) async {
    try {
      // Using set without merge to completely overwrite, matching typical update behavior.
      // If partial update is desired, use .update() with a Map.
      await _usersCollection.doc(user.uid).set(user);
      _logger.info('✅ User updated: ${user.uid}');
    } catch (e, stack) {
      _logger.severe('Error in updateUser for ${user.uid}: $e', e, stack);
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
    String? language,
    String? themeMode,
  }) async {
    try {
      final Map<String, dynamic> dataToUpdate = {};
      if (displayName != null) dataToUpdate['displayName'] = displayName;
      // For photoUrl, Firebase typically uses null to remove a field or an empty string.
      // Here, we only update if a non-null value is provided.
      if (photoUrl != null) dataToUpdate['photoUrl'] = photoUrl;
      if (language != null) dataToUpdate['language'] = language;
      if (themeMode != null) dataToUpdate['themeMode'] = themeMode;

      if (dataToUpdate.isNotEmpty) {
        await _usersCollection.doc(userId).update(dataToUpdate);
        _logger.info(
          '✅ Profile updated for user $userId with data: ${dataToUpdate.keys.join(', ')}.',
        );
      } else {
        _logger.info('No profile data to update for user $userId.');
      }
    } catch (e, stack) {
      _logger.severe('Error updating profile for $userId: $e', e, stack);
      // Consider rethrowing the error if the caller needs to handle it
      // throw;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
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
      await _usersCollection.doc(userId).update(data);
      _logger.info(
        '✅ Fields updated for user $userId: ${data.keys.join(', ')}',
      );
    } catch (e, stack) {
      _logger.severe('Error updating fields for $userId: $e', e, stack);
    }
  }

  @override
  Future<void> markTopicAsDone({
    required String userId,
    required String topicId,
    required String categoryId,
    required List<Topic> topicsForCategory,
  }) async {
    _logger.info(
      'Attempting to mark topic $topicId in category $categoryId as done for user $userId.',
    );
    try {
      final userDocRef = _usersCollection.doc(userId);
      final userSnapshot = await userDocRef.get();

      if (!userSnapshot.exists) {
        _logger.warning('User $userId not found for marking topic as done.');
        return;
      }

      // Explicitly check the type of the data.
      final userData = userSnapshot.data();
      if (userData == null) {
        _logger.warning(
          'User data is null for user $userId after snapshot.exists check.',
        );
        return;
      }
      final AppUser user = userData;

      // Update isTopicDone
      final updatedIsTopicDone = {
        ...user.isTopicDone,
        categoryId: {...(user.isTopicDone[categoryId] ?? {}), topicId: true},
      };

      // Calculate new progress for the category
      final passedCount =
          topicsForCategory
              .where(
                (topic) => updatedIsTopicDone[categoryId]?[topic.id] == true,
              )
              .length;
      final progress =
          topicsForCategory.isEmpty
              ? 0.0
              : passedCount / topicsForCategory.length;

      await userDocRef.update({
        'isTopicDone': updatedIsTopicDone,
        'categoryProgress.$categoryId': progress,
      });
      _logger.info(
        '✅ Topic $topicId marked as done for user $userId and progress updated.',
      );
    } catch (e, stack) {
      _logger.severe(
        'Error in markTopicAsDone for user $userId, topic $topicId: $e',
        e,
        stack,
      );
      throw Exception('Failed to mark topic as done: $e');
    }
  }
}
