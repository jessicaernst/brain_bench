import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('QuizAnswer Model', () {
    // --- Test Data ---
    const testId = 'qa-id-123';
    const testTopicId = 'topic-abc';
    const testCategoryId = 'cat-xyz';
    const testQuestionId = 'q-id-456';
    const testQuestionText = 'Sample Question Text?';
    final testGivenAnswers = ['ans1', 'ans3']; // User selected ans1 and ans3
    final testCorrectAnswers = ['ans1', 'ans2']; // Correct are ans1 and ans2
    final testIncorrectAnswers = [
      'ans3',
    ]; // Calculated: ans3 is given but not correct
    final testAllAnswers = ['ans1', 'ans2', 'ans3', 'ans4'];
    const testExplanation = 'This is why.';
    const testPointsEarned = 1;
    const testPossiblePoints = 2;

    // Instance using default factory
    final testQuizAnswer = QuizAnswer(
      id: testId,
      topicId: testTopicId,
      categoryId: testCategoryId,
      questionId: testQuestionId,
      questionText: testQuestionText,
      givenAnswers: testGivenAnswers,
      correctAnswers: testCorrectAnswers,
      incorrectAnswers: testIncorrectAnswers, // Must match calculation
      allAnswers: testAllAnswers,
      explanation: testExplanation,
      pointsEarned: testPointsEarned,
      possiblePoints: testPossiblePoints,
    );

    // Instance using default factory with default points
    final testQuizAnswerDefaultPoints = QuizAnswer(
      id: 'qa-id-def',
      topicId: testTopicId,
      categoryId: testCategoryId,
      questionId: testQuestionId,
      questionText: testQuestionText,
      givenAnswers: testGivenAnswers,
      correctAnswers: testCorrectAnswers,
      incorrectAnswers: testIncorrectAnswers,
      allAnswers: testAllAnswers,
      explanation: testExplanation,
      // pointsEarned and possiblePoints omitted to test default
    );

    // JSON representation
    final testJson = {
      'id': testId,
      'topicId': testTopicId,
      'categoryId': testCategoryId,
      'questionId': testQuestionId,
      'questionText': testQuestionText,
      'givenAnswers': testGivenAnswers,
      'correctAnswers': testCorrectAnswers,
      'incorrectAnswers': testIncorrectAnswers,
      'allAnswers': testAllAnswers,
      'explanation': testExplanation,
      'pointsEarned': testPointsEarned,
      'possiblePoints': testPossiblePoints,
    };

    // JSON representation for default points test
    final testJsonDefaultPoints = {
      'id': 'qa-id-def',
      'topicId': testTopicId,
      'categoryId': testCategoryId,
      'questionId': testQuestionId,
      'questionText': testQuestionText,
      'givenAnswers': testGivenAnswers,
      'correctAnswers': testCorrectAnswers,
      'incorrectAnswers': testIncorrectAnswers,
      'allAnswers': testAllAnswers,
      'explanation': testExplanation,
      'pointsEarned': 0, // Expected default
      'possiblePoints': 0, // Expected default
    };

    // --- Tests ---

    test(
      'Default factory constructor creates instance with correct values',
      () {
        // Arrange & Act: testQuizAnswer is already created

        // Assert
        expect(testQuizAnswer.id, testId);
        expect(testQuizAnswer.topicId, testTopicId);
        expect(testQuizAnswer.categoryId, testCategoryId);
        expect(testQuizAnswer.questionId, testQuestionId);
        expect(testQuizAnswer.questionText, testQuestionText);
        expect(testQuizAnswer.givenAnswers, testGivenAnswers);
        expect(testQuizAnswer.correctAnswers, testCorrectAnswers);
        expect(testQuizAnswer.incorrectAnswers, testIncorrectAnswers);
        expect(testQuizAnswer.allAnswers, testAllAnswers);
        expect(testQuizAnswer.explanation, testExplanation);
        expect(testQuizAnswer.pointsEarned, testPointsEarned);
        expect(testQuizAnswer.possiblePoints, testPossiblePoints);
      },
    );

    test(
      'Default factory constructor uses default points when not provided',
      () {
        // Arrange & Act: testQuizAnswerDefaultPoints is already created

        // Assert
        expect(testQuizAnswerDefaultPoints.pointsEarned, 0);
        expect(testQuizAnswerDefaultPoints.possiblePoints, 0);
      },
    );

    test(
      'QuizAnswer.create factory generates UUID and calculates incorrectAnswers',
      () {
        // Arrange
        const createTopicId = 'topic-create';
        const createCategoryId = 'cat-create';
        const createQuestionId = 'q-create';
        const createQuestionText = 'Create Question?';
        final createGiven = ['g1', 'g3', 'g4']; // Given
        final createCorrect = ['g1', 'g2', 'g4']; // Correct
        final createAll = ['g1', 'g2', 'g3', 'g4', 'g5'];
        const createExplanation = 'Create Exp';
        const createPoints = 5;
        const createPossible = 10;
        final expectedIncorrect = [
          'g3',
        ]; // Calculated: g3 is given but not correct

        // Act
        final createdQuizAnswer = QuizAnswer.create(
          topicId: createTopicId,
          categoryId: createCategoryId,
          questionId: createQuestionId,
          questionText: createQuestionText,
          givenAnswers: createGiven,
          correctAnswers: createCorrect,
          allAnswers: createAll,
          explanation: createExplanation,
          pointsEarned: createPoints,
          possiblePoints: createPossible,
        );

        // Assert
        expect(createdQuizAnswer.id, isNotEmpty);
        expect(
          Uuid.isValidUUID(
            fromString: createdQuizAnswer.id,
            validationMode: ValidationMode.strictRFC4122,
          ),
          isTrue,
        );
        expect(createdQuizAnswer.topicId, createTopicId);
        expect(createdQuizAnswer.categoryId, createCategoryId);
        expect(createdQuizAnswer.questionId, createQuestionId);
        expect(createdQuizAnswer.questionText, createQuestionText);
        expect(createdQuizAnswer.givenAnswers, createGiven);
        expect(createdQuizAnswer.correctAnswers, createCorrect);
        expect(
          createdQuizAnswer.incorrectAnswers,
          equals(expectedIncorrect),
        ); // Verify calculation
        expect(createdQuizAnswer.allAnswers, createAll);
        expect(createdQuizAnswer.explanation, createExplanation);
        expect(createdQuizAnswer.pointsEarned, createPoints);
        expect(createdQuizAnswer.possiblePoints, createPossible);
      },
    );

    test('QuizAnswer.create factory handles null explanation', () {
      // Arrange
      final createGiven = ['g1'];
      final createCorrect = ['g1'];
      final createAll = ['g1', 'g2'];

      // Act
      final createdQuizAnswer = QuizAnswer.create(
        topicId: 't',
        categoryId: 'c',
        questionId: 'q',
        questionText: 'qt',
        givenAnswers: createGiven,
        correctAnswers: createCorrect,
        allAnswers: createAll,
        explanation: null, // Explicitly null
        pointsEarned: 1,
        possiblePoints: 1,
      );

      // Assert
      expect(createdQuizAnswer.explanation, isNull);
      expect(
        createdQuizAnswer.incorrectAnswers,
        isEmpty,
      ); // Correct calculation
    });

    test('fromJson correctly deserializes JSON map', () {
      // Arrange: testJson is defined above

      // Act
      final answerFromJson = QuizAnswer.fromJson(testJson);

      // Assert
      expect(answerFromJson, equals(testQuizAnswer));
    });

    test(
      'fromJson correctly deserializes JSON map and applies default points',
      () {
        // Arrange
        final jsonWithoutPoints = Map<String, dynamic>.from(testJson);
        jsonWithoutPoints.remove('pointsEarned');
        jsonWithoutPoints.remove('possiblePoints');

        // Act
        final answerFromJson = QuizAnswer.fromJson(jsonWithoutPoints);

        // Assert
        expect(answerFromJson.id, testId);
        expect(answerFromJson.pointsEarned, 0); // Default applied
        expect(answerFromJson.possiblePoints, 0); // Default applied
      },
    );

    test('toJson correctly serializes object', () {
      // Arrange: testQuizAnswer is defined above

      // Act
      final jsonOutput = testQuizAnswer.toJson();

      // Assert
      expect(jsonOutput, equals(testJson));
    });

    test('toJson correctly serializes object with default points', () {
      // Arrange: testQuizAnswerDefaultPoints is defined above

      // Act
      final jsonOutput = testQuizAnswerDefaultPoints.toJson();

      // Assert
      expect(jsonOutput, equals(testJsonDefaultPoints));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final answer1 = QuizAnswer(
        id: 'eq-id',
        topicId: 't',
        categoryId: 'c',
        questionId: 'q',
        questionText: 'qt',
        givenAnswers: ['a'],
        correctAnswers: ['a'],
        incorrectAnswers: [],
        allAnswers: ['a', 'b'],
        pointsEarned: 1,
        possiblePoints: 1,
      );
      final answer2 = QuizAnswer(
        id: 'eq-id',
        topicId: 't',
        categoryId: 'c',
        questionId: 'q',
        questionText: 'qt',
        givenAnswers: ['a'],
        correctAnswers: ['a'],
        incorrectAnswers: [],
        allAnswers: ['a', 'b'],
        pointsEarned: 1,
        possiblePoints: 1,
      );

      // Act & Assert
      expect(answer1 == answer2, isTrue);
      expect(answer1.hashCode == answer2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final answer1 = QuizAnswer(
        id: 'diff-id-1',
        topicId: 't',
        categoryId: 'c',
        questionId: 'q',
        questionText: 'qt',
        givenAnswers: ['a'],
        correctAnswers: ['a'],
        incorrectAnswers: [],
        allAnswers: ['a', 'b'],
      );
      final answer2 = answer1.copyWith(id: 'diff-id-2'); // Different ID
      final answer3 = answer1.copyWith(pointsEarned: 5); // Different points
      final answer4 = answer1.copyWith(
        givenAnswers: ['b'],
      ); // Different given answers

      // Act & Assert
      expect(answer1 == answer2, isFalse);
      expect(answer1.hashCode == answer2.hashCode, isFalse);
      expect(answer1 == answer3, isFalse);
      expect(answer1.hashCode == answer3.hashCode, isFalse);
      expect(answer1 == answer4, isFalse);
      // Hash code might collide with list changes, but equality must be false
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testQuizAnswer is defined above

      // Act
      final copiedWithId = testQuizAnswer.copyWith(id: 'new-qa-id');
      final copiedWithPoints = testQuizAnswer.copyWith(
        pointsEarned: 0,
        possiblePoints: 1,
      );
      final copiedWithExplanation = testQuizAnswer.copyWith(
        explanation: 'New explanation.',
      );
      final copiedWithNullExplanation = testQuizAnswer.copyWith(
        explanation: null,
      );
      final copiedWithGiven = testQuizAnswer.copyWith(givenAnswers: ['ans1']);

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-qa-id');
      expect(copiedWithId.topicId, testQuizAnswer.topicId);
      expect(copiedWithId.pointsEarned, testQuizAnswer.pointsEarned);

      expect(copiedWithPoints.pointsEarned, 0);
      expect(copiedWithPoints.possiblePoints, 1);
      expect(copiedWithPoints.id, testQuizAnswer.id);

      expect(copiedWithExplanation.explanation, 'New explanation.');
      expect(copiedWithExplanation.id, testQuizAnswer.id);

      expect(copiedWithNullExplanation.explanation, isNull);
      expect(copiedWithNullExplanation.id, testQuizAnswer.id);

      expect(copiedWithGiven.givenAnswers, ['ans1']);
      expect(copiedWithGiven.id, testQuizAnswer.id);
      // Note: copyWith does NOT recalculate incorrectAnswers automatically
      expect(copiedWithGiven.incorrectAnswers, testQuizAnswer.incorrectAnswers);

      // Ensure original object is unchanged
      expect(testQuizAnswer.id, testId);
      expect(testQuizAnswer.pointsEarned, testPointsEarned);
    });
  });
}
