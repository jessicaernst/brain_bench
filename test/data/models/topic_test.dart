import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Topic Model', () {
    // --- Test Data ---
    const testId = 'topic-id-123';
    const testNameEn = 'Flutter Basics';
    const testNameDe = 'Flutter Grundlagen';
    const testDescriptionEn = 'Introduction to Flutter widgets and concepts.';
    const testDescriptionDe = 'Einführung in Flutter Widgets und Konzepte.';
    const testCategoryId = 'cat-prog-456';
    const testProgress = 0.75;

    // Instance using default factory with explicit progress
    final testTopicWithProgress = Topic(
      id: testId,
      nameEn: testNameEn,
      nameDe: testNameDe,
      descriptionEn: testDescriptionEn,
      descriptionDe: testDescriptionDe,
      categoryId: testCategoryId,
      progress: testProgress,
    );

    // Instance using default factory with default progress
    final testTopicDefaultProgress = Topic(
      id: 'topic-id-def',
      nameEn: 'State Management',
      nameDe: 'State Management',
      descriptionEn: 'Managing state in Flutter.',
      descriptionDe: 'Statusverwaltung in Flutter.',
      categoryId: testCategoryId,
      // progress omitted to test default
    );

    // JSON representation with progress
    final testJsonWithProgress = {
      'id': testId,
      'nameEn': testNameEn,
      'nameDe': testNameDe,
      'descriptionEn': testDescriptionEn,
      'descriptionDe': testDescriptionDe,
      'categoryId': testCategoryId,
      'progress': testProgress,
    };

    // JSON representation without progress (for default testing)
    final testJsonWithoutProgress = {
      'id': 'topic-id-def',
      'nameEn': 'State Management',
      'nameDe': 'State Management',
      'descriptionEn': 'Managing state in Flutter.',
      'descriptionDe': 'Statusverwaltung in Flutter.',
      'categoryId': testCategoryId,
      // progress field is missing
    };

    // --- Tests ---

    test(
      'Default factory constructor creates instance with correct values',
      () {
        // Arrange & Act: testTopicWithProgress is already created

        // Assert
        expect(testTopicWithProgress.id, testId);
        expect(testTopicWithProgress.nameEn, testNameEn);
        expect(testTopicWithProgress.nameDe, testNameDe);
        expect(testTopicWithProgress.descriptionEn, testDescriptionEn);
        expect(testTopicWithProgress.descriptionDe, testDescriptionDe);
        expect(testTopicWithProgress.categoryId, testCategoryId);
        expect(testTopicWithProgress.progress, testProgress);
      },
    );

    test(
      'Default factory constructor uses default progress when not provided',
      () {
        // Arrange & Act: testTopicDefaultProgress is already created

        // Assert
        expect(testTopicDefaultProgress.progress, 0.0); // Verify default value
      },
    );

    test(
      'Topic.create factory generates UUID and sets properties with default progress',
      () {
        // Arrange
        const createNameEn = 'Dart Language';
        const createNameDe = 'Dart Sprache';
        const createDescriptionEn = 'Fundamentals of Dart.';
        const createDescriptionDe = 'Grundlagen von Dart.';
        const createCategoryId = 'cat-lang-789';

        // Act
        final createdTopic = Topic.create(
          nameEn: createNameEn,
          nameDe: createNameDe,
          descriptionEn: createDescriptionEn,
          descriptionDe: createDescriptionDe,
          categoryId: createCategoryId,
        );

        // Assert
        expect(createdTopic.id, isNotEmpty);
        expect(
          Uuid.isValidUUID(
            fromString: createdTopic.id,
            validationMode: ValidationMode.strictRFC4122,
          ),
          isTrue,
        );
        expect(createdTopic.nameEn, createNameEn);
        expect(createdTopic.nameDe, createNameDe);
        expect(createdTopic.descriptionEn, createDescriptionEn);
        expect(createdTopic.descriptionDe, createDescriptionDe);
        expect(createdTopic.categoryId, createCategoryId);
        expect(createdTopic.progress, 0.0); // Verify default progress
      },
    );

    test('fromJson correctly deserializes JSON map with progress', () {
      // Arrange: testJsonWithProgress is defined above

      // Act
      final topicFromJson = Topic.fromJson(testJsonWithProgress);

      // Assert
      expect(topicFromJson, equals(testTopicWithProgress));
    });

    test(
      'fromJson correctly deserializes JSON map and applies default progress',
      () {
        // Arrange: testJsonWithoutProgress is defined above

        // Act
        final topicFromJson = Topic.fromJson(testJsonWithoutProgress);

        // Assert
        // Compare field by field because the original object was created with default
        expect(topicFromJson.id, testTopicDefaultProgress.id);
        expect(topicFromJson.nameEn, testTopicDefaultProgress.nameEn);
        expect(topicFromJson.nameDe, testTopicDefaultProgress.nameDe);
        expect(
          topicFromJson.descriptionEn,
          testTopicDefaultProgress.descriptionEn,
        );
        expect(
          topicFromJson.descriptionDe,
          testTopicDefaultProgress.descriptionDe,
        );
        expect(topicFromJson.categoryId, testTopicDefaultProgress.categoryId);
        expect(
          topicFromJson.progress,
          0.0,
        ); // Default applied during deserialization
        // Or compare directly if the default object was created without specifying progress
        expect(topicFromJson, equals(testTopicDefaultProgress));
      },
    );

    test('toJson correctly serializes object with explicit progress', () {
      // Arrange: testTopicWithProgress is defined above

      // Act
      final jsonOutput = testTopicWithProgress.toJson();

      // Assert
      expect(jsonOutput, equals(testJsonWithProgress));
    });

    test('toJson correctly serializes object with default progress', () {
      // Arrange: testTopicDefaultProgress is defined above
      // Expected JSON should include the default progress value
      final expectedJson = Map<String, dynamic>.from(testJsonWithoutProgress);
      expectedJson['progress'] = 0.0; // Add default progress to expected JSON

      // Act
      final jsonOutput = testTopicDefaultProgress.toJson();

      // Assert
      expect(jsonOutput, equals(expectedJson));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final topic1 = Topic(
        id: 'eq-id',
        nameEn: 'Name',
        nameDe: 'NameDe',
        descriptionEn: 'Desc',
        descriptionDe: 'DescDe',
        categoryId: 'cat',
        progress: 0.5,
      );
      final topic2 = Topic(
        id: 'eq-id',
        nameEn: 'Name',
        nameDe: 'NameDe',
        descriptionEn: 'Desc',
        descriptionDe: 'DescDe',
        categoryId: 'cat',
        progress: 0.5,
      );

      // Act & Assert
      expect(topic1 == topic2, isTrue);
      expect(topic1.hashCode == topic2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final topic1 = Topic(
        id: 'diff-id-1',
        nameEn: 'Name1',
        nameDe: 'NameDe1',
        descriptionEn: 'Desc1',
        descriptionDe: 'DescDe1',
        categoryId: 'cat1',
        progress: 0.1,
      );
      final topic2 = topic1.copyWith(id: 'diff-id-2'); // Different ID
      final topic3 = topic1.copyWith(nameDe: 'NameDe2'); // Different nameDe
      final topic4 = topic1.copyWith(
        categoryId: 'cat2',
      ); // Different categoryId
      final topic5 = topic1.copyWith(progress: 0.9); // Different progress

      // Act & Assert
      expect(topic1 == topic2, isFalse);
      expect(topic1.hashCode == topic2.hashCode, isFalse);
      expect(topic1 == topic3, isFalse);
      expect(topic1.hashCode == topic3.hashCode, isFalse);
      expect(topic1 == topic4, isFalse);
      expect(topic1.hashCode == topic4.hashCode, isFalse);
      expect(topic1 == topic5, isFalse);
      expect(topic1.hashCode == topic5.hashCode, isFalse);
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testTopicWithProgress is defined above

      // Act
      final copiedWithId = testTopicWithProgress.copyWith(id: 'new-topic-id');
      final copiedWithNameEn = testTopicWithProgress.copyWith(
        nameEn: 'Advanced Flutter',
      );
      final copiedWithDescriptionDe = testTopicWithProgress.copyWith(
        descriptionDe: 'Fortgeschritten.',
      );
      final copiedWithCategoryId = testTopicWithProgress.copyWith(
        categoryId: 'new-cat-id',
      );
      final copiedWithProgress = testTopicWithProgress.copyWith(progress: 1.0);

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-topic-id');
      expect(copiedWithId.nameEn, testTopicWithProgress.nameEn);
      expect(copiedWithId.progress, testTopicWithProgress.progress);

      expect(copiedWithNameEn.nameEn, 'Advanced Flutter');
      expect(copiedWithNameEn.id, testTopicWithProgress.id);
      expect(
        copiedWithNameEn.descriptionEn,
        testTopicWithProgress.descriptionEn,
      );

      expect(copiedWithDescriptionDe.descriptionDe, 'Fortgeschritten.');
      expect(copiedWithDescriptionDe.id, testTopicWithProgress.id);

      expect(copiedWithCategoryId.categoryId, 'new-cat-id');
      expect(copiedWithCategoryId.id, testTopicWithProgress.id);

      expect(copiedWithProgress.progress, 1.0);
      expect(copiedWithProgress.id, testTopicWithProgress.id);
      expect(copiedWithProgress.nameDe, testTopicWithProgress.nameDe);

      // Ensure original object is unchanged
      expect(testTopicWithProgress.id, testId);
      expect(testTopicWithProgress.progress, testProgress);
    });
  });
}
