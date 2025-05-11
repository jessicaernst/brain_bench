import 'package:brain_bench/data/models/category/category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Category Model', () {
    // --- Test Data ---
    const testId = 'cat-id-123';
    const testNameEn = 'Programming';
    const testNameDe = 'Programmieren';
    const testSubtitleEn = 'Learn coding concepts';
    const testSubtitleDe = 'Lerne Programmierkonzepte';
    const testDescriptionEn =
        'Covers various programming languages and paradigms.';
    const testDescriptionDe =
        'Beinhaltet verschiedene Programmiersprachen und Paradigmen.';

    final testCategory = Category(
      id: testId,
      nameEn: testNameEn,
      nameDe: testNameDe,
      subtitleEn: testSubtitleEn,
      subtitleDe: testSubtitleDe,
      descriptionEn: testDescriptionEn,
      descriptionDe: testDescriptionDe,
    );

    final testJson = {
      'id': testId,
      'nameEn': testNameEn,
      'nameDe': testNameDe,
      'subtitleEn': testSubtitleEn,
      'subtitleDe': testSubtitleDe,
      'descriptionEn': testDescriptionEn,
      'descriptionDe': testDescriptionDe,
    };

    // --- Tests ---

    test(
      'Default factory constructor creates instance with correct values',
      () {
        // Arrange & Act: testCategory is already created

        // Assert
        expect(testCategory.id, testId);
        expect(testCategory.nameEn, testNameEn);
        expect(testCategory.nameDe, testNameDe);
        expect(testCategory.subtitleEn, testSubtitleEn);
        expect(testCategory.subtitleDe, testSubtitleDe);
        expect(testCategory.descriptionEn, testDescriptionEn);
        expect(testCategory.descriptionDe, testDescriptionDe);
      },
    );

    test(
      'Category.create factory generates a valid UUID and sets properties',
      () {
        // Arrange
        const createNameEn = 'History';
        const createNameDe = 'Geschichte';
        const createSubtitleEn = 'World events';
        const createSubtitleDe = 'Weltereignisse';
        const createDescriptionEn = 'From ancient times to modern day.';
        const createDescriptionDe = 'Von der Antike bis zur Neuzeit.';

        // Act
        final createdCategory = Category.create(
          nameEn: createNameEn,
          nameDe: createNameDe,
          subtitleEn: createSubtitleEn,
          subtitleDe: createSubtitleDe,
          descriptionEn: createDescriptionEn,
          descriptionDe: createDescriptionDe,
        );

        // Assert
        expect(createdCategory.id, isNotEmpty);
        // Basic check if it looks like a UUID v4
        expect(
          Uuid.isValidUUID(
            fromString: createdCategory.id,
            validationMode: ValidationMode.strictRFC4122,
          ),
          isTrue,
        );
        expect(createdCategory.nameEn, createNameEn);
        expect(createdCategory.nameDe, createNameDe);
        expect(createdCategory.subtitleEn, createSubtitleEn);
        expect(createdCategory.subtitleDe, createSubtitleDe);
        expect(createdCategory.descriptionEn, createDescriptionEn);
        expect(createdCategory.descriptionDe, createDescriptionDe);
      },
    );

    test('fromJson correctly deserializes JSON map', () {
      // Arrange: testJson is defined above

      // Act
      final categoryFromJson = Category.fromJson(testJson);

      // Assert
      expect(categoryFromJson, equals(testCategory));
    });

    test('toJson correctly serializes object', () {
      // Arrange: testCategory is defined above

      // Act
      final jsonOutput = testCategory.toJson();

      // Assert
      expect(jsonOutput, equals(testJson));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final category1 = Category(
        id: 'eq-id',
        nameEn: 'Name',
        nameDe: 'NameDe',
        subtitleEn: 'Sub',
        subtitleDe: 'SubDe',
        descriptionEn: 'Desc',
        descriptionDe: 'DescDe',
      );
      final category2 = Category(
        id: 'eq-id',
        nameEn: 'Name',
        nameDe: 'NameDe',
        subtitleEn: 'Sub',
        subtitleDe: 'SubDe',
        descriptionEn: 'Desc',
        descriptionDe: 'DescDe',
      );

      // Act & Assert
      expect(category1 == category2, isTrue);
      expect(category1.hashCode == category2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final category1 = Category(
        id: 'diff-id-1',
        nameEn: 'Name1',
        nameDe: 'NameDe1',
        subtitleEn: 'Sub1',
        subtitleDe: 'SubDe1',
        descriptionEn: 'Desc1',
        descriptionDe: 'DescDe1',
      );
      final category2 = category1.copyWith(id: 'diff-id-2'); // Different ID
      final category3 = category1.copyWith(nameEn: 'Name2'); // Different nameEn
      final category4 = category1.copyWith(
        subtitleDe: 'SubDe2',
      ); // Different subtitleDe
      final category5 = category1.copyWith(
        descriptionEn: 'Desc2',
      ); // Different descriptionEn

      // Act & Assert
      expect(category1 == category2, isFalse);
      expect(category1.hashCode == category2.hashCode, isFalse);
      expect(category1 == category3, isFalse);
      expect(category1.hashCode == category3.hashCode, isFalse);
      expect(category1 == category4, isFalse);
      expect(category1.hashCode == category4.hashCode, isFalse);
      expect(category1 == category5, isFalse);
      expect(category1.hashCode == category5.hashCode, isFalse);
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testCategory is defined above

      // Act
      final copiedWithId = testCategory.copyWith(id: 'new-cat-id');
      final copiedWithNameEn = testCategory.copyWith(nameEn: 'Science');
      final copiedWithNameDe = testCategory.copyWith(nameDe: 'Wissenschaft');
      final copiedWithSubtitleEn = testCategory.copyWith(
        subtitleEn: 'Explore the world',
      );
      final copiedWithSubtitleDe = testCategory.copyWith(
        subtitleDe: 'Erkunde die Welt',
      );
      final copiedWithDescriptionEn = testCategory.copyWith(
        descriptionEn: 'New description.',
      );
      final copiedWithDescriptionDe = testCategory.copyWith(
        descriptionDe: 'Neue Beschreibung.',
      );

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-cat-id');
      expect(copiedWithId.nameEn, testCategory.nameEn);
      expect(copiedWithId.descriptionDe, testCategory.descriptionDe);

      expect(copiedWithNameEn.nameEn, 'Science');
      expect(copiedWithNameEn.id, testCategory.id);
      expect(copiedWithNameEn.subtitleEn, testCategory.subtitleEn);

      expect(copiedWithNameDe.nameDe, 'Wissenschaft');
      expect(copiedWithNameDe.id, testCategory.id);

      expect(copiedWithSubtitleEn.subtitleEn, 'Explore the world');
      expect(copiedWithSubtitleEn.id, testCategory.id);

      expect(copiedWithSubtitleDe.subtitleDe, 'Erkunde die Welt');
      expect(copiedWithSubtitleDe.id, testCategory.id);

      expect(copiedWithDescriptionEn.descriptionEn, 'New description.');
      expect(copiedWithDescriptionEn.id, testCategory.id);

      expect(copiedWithDescriptionDe.descriptionDe, 'Neue Beschreibung.');
      expect(copiedWithDescriptionDe.id, testCategory.id);

      // Ensure original object is unchanged
      expect(testCategory.id, testId);
      expect(testCategory.nameEn, testNameEn);
    });
  });
}
