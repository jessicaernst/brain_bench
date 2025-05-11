import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Answer Model', () {
    // --- Test Data ---
    const testId = 'test-id-123';
    const testTextEn = 'Test Answer English';
    const testTextDe = 'Test Antwort Deutsch';
    const testIsCorrect = true;

    final testAnswer = Answer(
      id: testId,
      textEn: testTextEn,
      textDe: testTextDe,
      isCorrect: testIsCorrect,
      // isSelected defaults to false
    );

    final testJson = {
      'id': testId,
      'textEn': testTextEn,
      'textDe': testTextDe,
      'isCorrect': testIsCorrect,
      // 'isSelected' should NOT be in the JSON
    };

    // --- Tests ---

    test(
      'Default constructor creates instance with correct values and default isSelected',
      () {
        // Arrange & Act: testAnswer is already created

        // Assert
        expect(testAnswer.id, testId);
        expect(testAnswer.textEn, testTextEn);
        expect(testAnswer.textDe, testTextDe);
        expect(testAnswer.isCorrect, testIsCorrect);
        expect(testAnswer.isSelected, false); // Verify default value
      },
    );

    test(
      'Answer.create factory generates a valid UUID and sets properties',
      () {
        // Arrange
        const createTextEn = 'Created Answer EN';
        const createTextDe = 'Erstellte Antwort DE';
        const createIsCorrect = false;

        // Act
        final createdAnswer = Answer.create(
          textEn: createTextEn,
          textDe: createTextDe,
          isCorrect: createIsCorrect,
        );

        // Assert
        expect(createdAnswer.id, isNotEmpty);
        // Basic check if it looks like a UUID v4
        expect(
          Uuid.isValidUUID(
            fromString: createdAnswer.id,
            validationMode: ValidationMode.strictRFC4122,
          ),
          isTrue,
        );
        expect(createdAnswer.textEn, createTextEn);
        expect(createdAnswer.textDe, createTextDe);
        expect(createdAnswer.isCorrect, createIsCorrect);
        expect(createdAnswer.isSelected, false); // Default value
      },
    );

    test('fromJson correctly deserializes JSON map', () {
      // Arrange: testJson is defined above

      // Act
      final answerFromJson = Answer.fromJson(testJson);

      // Assert
      expect(answerFromJson.id, testId);
      expect(answerFromJson.textEn, testTextEn);
      expect(answerFromJson.textDe, testTextDe);
      expect(answerFromJson.isCorrect, testIsCorrect);
      expect(
        answerFromJson.isSelected,
        false,
      ); // Should not be in JSON, defaults to false
    });

    test('toJson correctly serializes object, excluding isSelected', () {
      // Arrange: testAnswer is defined above
      // Create another instance with isSelected = true to ensure it's excluded
      final selectedAnswer = testAnswer.copyWith(isSelected: true);

      // Act
      final jsonOutput = selectedAnswer.toJson();

      // Assert
      expect(
        jsonOutput,
        equals(testJson),
      ); // Should match the predefined JSON without isSelected
      expect(
        jsonOutput.containsKey('isSelected'),
        isFalse,
      ); // Explicitly check exclusion
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final answer1 = Answer(
        id: 'eq-id',
        textEn: 'Equal EN',
        textDe: 'Gleich DE',
        isCorrect: true,
      );
      final answer2 = Answer(
        id: 'eq-id',
        textEn: 'Equal EN',
        textDe: 'Gleich DE',
        isCorrect: true,
      );

      // Act & Assert
      expect(answer1 == answer2, isTrue);
      expect(answer1.hashCode == answer2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final answer1 = Answer(
        id: 'diff-id-1',
        textEn: 'Different EN 1',
        textDe: 'Anders DE 1',
        isCorrect: true,
      );
      final answer2 = Answer(
        id: 'diff-id-2', // Different ID
        textEn: 'Different EN 1',
        textDe: 'Anders DE 1',
        isCorrect: true,
      );
      final answer3 = Answer(
        id: 'diff-id-1',
        textEn: 'Different EN 2', // Different text
        textDe: 'Anders DE 1',
        isCorrect: true,
      );
      final answer4 = Answer(
        id: 'diff-id-1',
        textEn: 'Different EN 1',
        textDe: 'Anders DE 1',
        isCorrect: false, // Different correctness
      );

      // Act & Assert
      expect(answer1 == answer2, isFalse);
      expect(answer1.hashCode == answer2.hashCode, isFalse);
      expect(answer1 == answer3, isFalse);
      expect(answer1.hashCode == answer3.hashCode, isFalse);
      expect(answer1 == answer4, isFalse);
      expect(answer1.hashCode == answer4.hashCode, isFalse);
    });

    test('Equality operator (==) ignores isSelected field', () {
      // Arrange
      final answer1 = Answer(
        id: 'sel-id',
        textEn: 'Select EN',
        textDe: 'Wählen DE',
        isCorrect: true,
        isSelected: false, // Default
      );
      final answer2 = Answer(
        id: 'sel-id',
        textEn: 'Select EN',
        textDe: 'Wählen DE',
        isCorrect: true,
        isSelected: true, // Different isSelected
      );

      // Act & Assert
      // Freezed's implementation of == typically includes all fields unless excluded.
      // Since isSelected is NOT part of the factory constructor used for equality
      // and is marked with @JsonKey(includeFromJson: false, includeToJson: false),
      // it might be excluded from equality by default, but let's verify.
      // If this fails, it means isSelected *is* part of equality, which might be unexpected.
      expect(
        answer1 == answer2,
        isFalse,
      ); // Expect them to be different due to isSelected
      expect(
        answer1.hashCode == answer2.hashCode,
        isFalse,
      ); // Hash codes should also differ
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testAnswer is defined above

      // Act
      final copiedWithId = testAnswer.copyWith(id: 'new-id');
      final copiedWithTextEn = testAnswer.copyWith(textEn: 'New English');
      final copiedWithTextDe = testAnswer.copyWith(textDe: 'Neue Deutsche');
      final copiedWithIsCorrect = testAnswer.copyWith(isCorrect: false);
      final copiedWithIsSelected = testAnswer.copyWith(isSelected: true);

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-id');
      expect(copiedWithId.textEn, testAnswer.textEn);
      expect(copiedWithId.isSelected, testAnswer.isSelected);

      expect(copiedWithTextEn.textEn, 'New English');
      expect(copiedWithTextEn.id, testAnswer.id);
      expect(copiedWithTextEn.isCorrect, testAnswer.isCorrect);

      expect(copiedWithTextDe.textDe, 'Neue Deutsche');
      expect(copiedWithTextDe.id, testAnswer.id);

      expect(copiedWithIsCorrect.isCorrect, false);
      expect(copiedWithIsCorrect.id, testAnswer.id);

      expect(copiedWithIsSelected.isSelected, true);
      expect(copiedWithIsSelected.id, testAnswer.id);
      expect(copiedWithIsSelected.isCorrect, testAnswer.isCorrect);

      // Ensure original object is unchanged
      expect(testAnswer.id, testId);
      expect(testAnswer.isSelected, false);
    });
  });
}
