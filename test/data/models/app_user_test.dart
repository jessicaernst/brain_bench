import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUser Model', () {
    // --- Test Data ---
    const testId = 'user-doc-id-123'; // Firestore document ID
    const testUid = 'auth-uid-456'; // Firebase Auth UID
    const testEmail = 'test@example.com';
    const testDisplayName = 'Test User';
    const testPhotoUrl = 'http://example.com/photo.jpg'; // From Auth provider
    const testProfileImageUrl =
        'http://storage.com/profile.png'; // Custom uploaded
    const testThemeMode = 'dark';
    const testLanguage = 'de';
    final testCategoryProgress = {'cat1': 0.5, 'cat2': 1.0};
    final testIsTopicDone = {
      'cat1': {'topic1': true, 'topic2': false},
      'cat2': {'topic3': true}
    };

    // Instance with all fields provided
    final testAppUser = AppUser(
      id: testId,
      uid: testUid,
      email: testEmail,
      displayName: testDisplayName,
      photoUrl: testPhotoUrl,
      profileImageUrl: testProfileImageUrl,
      themeMode: testThemeMode,
      language: testLanguage,
      categoryProgress: testCategoryProgress,
      isTopicDone: testIsTopicDone,
    );

    // Instance relying on default values
    final testAppUserDefault = AppUser(
      id: 'user-doc-id-def',
      uid: 'auth-uid-def',
      email: 'default@example.com',
      // displayName, photoUrl, profileImageUrl are null
      // themeMode, language, categoryProgress, isTopicDone use defaults
    );

    // JSON representation for the full user
    final testJson = {
      'id': testId,
      'uid': testUid,
      'email': testEmail,
      'displayName': testDisplayName,
      'photoUrl': testPhotoUrl,
      'profileImageUrl': testProfileImageUrl,
      'themeMode': testThemeMode,
      'language': testLanguage,
      'categoryProgress': testCategoryProgress,
      'isTopicDone': testIsTopicDone,
    };

    // JSON representation for the user relying on defaults (only required fields)
    final testJsonDefaults = {
      'id': 'user-doc-id-def',
      'uid': 'auth-uid-def',
      'email': 'default@example.com',
      // Optional fields are missing, defaults should be applied on deserialization
    };

    // --- Tests ---

    test('Default factory constructor creates instance with correct values',
        () {
      // Arrange & Act: testAppUser is already created

      // Assert
      expect(testAppUser.id, testId);
      expect(testAppUser.uid, testUid);
      expect(testAppUser.email, testEmail);
      expect(testAppUser.displayName, testDisplayName);
      expect(testAppUser.photoUrl, testPhotoUrl);
      expect(testAppUser.profileImageUrl, testProfileImageUrl);
      expect(testAppUser.themeMode, testThemeMode);
      expect(testAppUser.language, testLanguage);
      expect(testAppUser.categoryProgress, testCategoryProgress);
      expect(testAppUser.isTopicDone, testIsTopicDone);
    });

    test('Default factory constructor applies default values correctly', () {
      // Arrange & Act: testAppUserDefault is already created

      // Assert
      expect(testAppUserDefault.id, 'user-doc-id-def');
      expect(testAppUserDefault.uid, 'auth-uid-def');
      expect(testAppUserDefault.email, 'default@example.com');
      expect(testAppUserDefault.displayName, isNull);
      expect(testAppUserDefault.photoUrl, isNull);
      expect(testAppUserDefault.profileImageUrl, isNull);
      expect(testAppUserDefault.themeMode, 'system'); // Default
      expect(testAppUserDefault.language, 'en'); // Default
      expect(testAppUserDefault.categoryProgress, isEmpty); // Default
      expect(testAppUserDefault.isTopicDone, isEmpty); // Default
    });

    test('fromJson correctly deserializes JSON map with all fields', () {
      // Arrange: testJson is defined above

      // Act
      final userFromJson = AppUser.fromJson(testJson);

      // Assert
      expect(userFromJson, equals(testAppUser));
    });

    test('fromJson correctly deserializes JSON map and applies defaults', () {
      // Arrange: testJsonDefaults is defined above

      // Act
      final userFromJson = AppUser.fromJson(testJsonDefaults);

      // Assert
      // Compare field by field because the original default object was created differently
      expect(userFromJson.id, testAppUserDefault.id);
      expect(userFromJson.uid, testAppUserDefault.uid);
      expect(userFromJson.email, testAppUserDefault.email);
      expect(userFromJson.displayName, isNull);
      expect(userFromJson.photoUrl, isNull);
      expect(userFromJson.profileImageUrl, isNull);
      expect(userFromJson.themeMode, 'system'); // Default applied
      expect(userFromJson.language, 'en'); // Default applied
      expect(userFromJson.categoryProgress, isEmpty); // Default applied
      expect(userFromJson.isTopicDone, isEmpty); // Default applied

      // Or compare directly to the default object
      expect(userFromJson, equals(testAppUserDefault));
    });

    test('toJson correctly serializes object with all fields', () {
      // Arrange: testAppUser is defined above

      // Act
      final jsonOutput = testAppUser.toJson();

      // Assert
      expect(jsonOutput, equals(testJson));
    });

    test('toJson correctly serializes object with default values', () {
      // Arrange: testAppUserDefault is defined above
      // Expected JSON should include the default values when serializing
      final expectedJson = {
        'id': 'user-doc-id-def',
        'uid': 'auth-uid-def',
        'email': 'default@example.com',
        'displayName': null,
        'photoUrl': null,
        'profileImageUrl': null,
        'themeMode': 'system', // Default included
        'language': 'en', // Default included
        'categoryProgress': {}, // Default included
        'isTopicDone': {}, // Default included
      };

      // Act
      final jsonOutput = testAppUserDefault.toJson();

      // Assert
      expect(jsonOutput, equals(expectedJson));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final user1 = AppUser(
        id: 'eq-id',
        uid: 'eq-uid',
        email: 'eq@example.com',
        categoryProgress: {'a': 1.0},
        isTopicDone: {
          'a': {'t': true}
        },
      );
      final user2 = AppUser(
        id: 'eq-id',
        uid: 'eq-uid',
        email: 'eq@example.com',
        categoryProgress: {'a': 1.0},
        isTopicDone: {
          'a': {'t': true}
        },
      );

      // Act & Assert
      expect(user1 == user2, isTrue);
      expect(user1.hashCode == user2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final user1 = AppUser(
        id: 'diff-id-1',
        uid: 'diff-uid-1',
        email: 'diff1@example.com',
      );
      final user2 = user1.copyWith(id: 'diff-id-2'); // Different id
      final user3 = user1.copyWith(uid: 'diff-uid-2'); // Different uid
      final user4 =
          user1.copyWith(email: 'diff2@example.com'); // Different email
      final user5 = user1.copyWith(displayName: 'Name'); // Added optional field
      final user6 =
          user1.copyWith(themeMode: 'light'); // Different default field
      final user7 =
          user1.copyWith(categoryProgress: {'a': 0.1}); // Added map field

      // Act & Assert
      expect(user1 == user2, isFalse);
      expect(user1.hashCode == user2.hashCode, isFalse);
      expect(user1 == user3, isFalse);
      expect(user1.hashCode == user3.hashCode, isFalse);
      expect(user1 == user4, isFalse);
      expect(user1.hashCode == user4.hashCode, isFalse);
      expect(user1 == user5, isFalse);
      expect(user1.hashCode == user5.hashCode, isFalse);
      expect(user1 == user6, isFalse);
      expect(user1.hashCode == user6.hashCode, isFalse);
      expect(user1 == user7, isFalse);
      // Hash code might collide with map changes, but equality must be false
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testAppUser is defined above

      // Act
      final copiedWithId = testAppUser.copyWith(id: 'new-doc-id');
      final copiedWithUid = testAppUser.copyWith(uid: 'new-auth-uid');
      final copiedWithEmail = testAppUser.copyWith(email: 'new@example.com');
      final copiedWithDisplayName =
          testAppUser.copyWith(displayName: 'New Name');
      final copiedWithNullDisplayName = testAppUser.copyWith(displayName: null);
      final copiedWithPhotoUrl =
          testAppUser.copyWith(photoUrl: 'http://new.com/photo.png');
      final copiedWithProfileImageUrl =
          testAppUser.copyWith(profileImageUrl: 'http://new.com/profile.gif');
      final copiedWithTheme = testAppUser.copyWith(themeMode: 'light');
      final copiedWithLang = testAppUser.copyWith(language: 'es');
      final copiedWithProgress =
          testAppUser.copyWith(categoryProgress: {'newCat': 0.1});
      final copiedWithTopicDone = testAppUser.copyWith(isTopicDone: {
        'newCat': {'newTopic': true}
      });

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-doc-id');
      expect(copiedWithId.uid, testAppUser.uid);
      expect(copiedWithId.language, testAppUser.language);

      expect(copiedWithUid.uid, 'new-auth-uid');
      expect(copiedWithUid.id, testAppUser.id);

      expect(copiedWithEmail.email, 'new@example.com');
      expect(copiedWithEmail.id, testAppUser.id);

      expect(copiedWithDisplayName.displayName, 'New Name');
      expect(copiedWithDisplayName.id, testAppUser.id);

      expect(copiedWithNullDisplayName.displayName, isNull);
      expect(copiedWithNullDisplayName.id, testAppUser.id);

      expect(copiedWithPhotoUrl.photoUrl, 'http://new.com/photo.png');
      expect(copiedWithPhotoUrl.id, testAppUser.id);

      expect(copiedWithProfileImageUrl.profileImageUrl,
          'http://new.com/profile.gif');
      expect(copiedWithProfileImageUrl.id, testAppUser.id);

      expect(copiedWithTheme.themeMode, 'light');
      expect(copiedWithTheme.id, testAppUser.id);

      expect(copiedWithLang.language, 'es');
      expect(copiedWithLang.id, testAppUser.id);

      expect(copiedWithProgress.categoryProgress, {'newCat': 0.1});
      expect(copiedWithProgress.id, testAppUser.id);

      expect(copiedWithTopicDone.isTopicDone, {
        'newCat': {'newTopic': true}
      });
      expect(copiedWithTopicDone.id, testAppUser.id);

      // Ensure original object is unchanged
      expect(testAppUser.id, testId);
      expect(testAppUser.displayName, testDisplayName);
      expect(testAppUser.themeMode, testThemeMode);
    });
  });
}
