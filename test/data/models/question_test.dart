import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Question Model', () {
    // --- Test Data ---
    const testId = 'q-test-id-456';
    const testTopicId = 'topic-abc';
    const testQuestionText = 'What is Flutter?';
    const testType = QuestionType.singleChoice;
    final testAnswerIds = ['ans-1', 'ans-2', 'ans-3'];
    const testExplanation = 'Flutter is a UI toolkit.';

    final testQuestion = Question(
      id: testId,
      topicId: testTopicId,
      question: testQuestionText,
      type: testType,
      answerIds: testAnswerIds,
      explanation: testExplanation,
    );

    final testQuestionWithoutExplanation = Question(
      id: 'q-no-exp-789',
      topicId: testTopicId,
      question: 'Another question?',
      type: QuestionType.multipleChoice,
      answerIds: ['ans-4', 'ans-5'],
      explanation: null, // Explicitly null
    );

    final testJson = {
      'id': testId,
      'topicId': testTopicId,
      'question': testQuestionText,
      'type': 'singleChoice', // Enum serialized as string
      'answerIds': testAnswerIds,
      'explanation': testExplanation,
    };

    final testJsonWithoutExplanation = {
      'id': 'q-no-exp-789',
      'topicId': testTopicId,
      'question': 'Another question?',
      'type': 'multipleChoice',
      'answerIds': ['ans-4', 'ans-5'],
      'explanation': null,
    };

    // --- Tests ---

    test('Default constructor creates instance with correct values', () {
      // Arrange & Act: testQuestion is already created

      // Assert
      expect(testQuestion.id, testId);
      expect(testQuestion.topicId, testTopicId);
      expect(testQuestion.question, testQuestionText);
      expect(testQuestion.type, testType);
      expect(testQuestion.answerIds, testAnswerIds);
      expect(testQuestion.explanation, testExplanation);
    });

    test('Default constructor handles null explanation correctly', () {
      // Arrange & Act: testQuestionWithoutExplanation is already created

      // Assert
      expect(testQuestionWithoutExplanation.id, 'q-no-exp-789');
      expect(testQuestionWithoutExplanation.topicId, testTopicId);
      expect(testQuestionWithoutExplanation.explanation, isNull);
    });

    test(
      'Question.create factory generates a valid UUID and sets properties',
      () {
        // Arrange
        const createTopicId = 'new-topic';
        const createQuestionText = 'Create question?';
        const createType = QuestionType.multipleChoice;
        final createAnswerIds = ['new-ans-1', 'new-ans-2'];
        const createExplanation = 'Explanation for created question.';

        // Act
        final createdQuestion = Question.create(
          topicId: createTopicId,
          question: createQuestionText,
          type: createType,
          answerIds: createAnswerIds,
          explanation: createExplanation,
        );

        // Assert
        expect(createdQuestion.id, isNotEmpty);
        // Basic check if it looks like a UUID v4
        expect(
          Uuid.isValidUUID(
            fromString: createdQuestion.id,
            validationMode: ValidationMode.strictRFC4122,
          ),
          isTrue,
        );
        expect(createdQuestion.topicId, createTopicId);
        expect(createdQuestion.question, createQuestionText);
        expect(createdQuestion.type, createType);
        expect(createdQuestion.answerIds, createAnswerIds);
        expect(createdQuestion.explanation, createExplanation);
      },
    );

    test('Question.create factory handles null explanation', () {
      // Arrange
      const createTopicId = 'new-topic-no-exp';
      const createQuestionText = 'Create question no exp?';
      const createType = QuestionType.singleChoice;
      final createAnswerIds = ['new-ans-3'];

      // Act
      final createdQuestion = Question.create(
        topicId: createTopicId,
        question: createQuestionText,
        type: createType,
        answerIds: createAnswerIds,
        // explanation is omitted, should default to null
      );

      // Assert
      expect(createdQuestion.id, isNotEmpty);
      expect(createdQuestion.topicId, createTopicId);
      expect(createdQuestion.explanation, isNull);
    });

    test('fromJson correctly deserializes JSON map with explanation', () {
      // Arrange: testJson is defined above

      // Act
      final questionFromJson = Question.fromJson(testJson);

      // Assert
      expect(questionFromJson.id, testId);
      expect(questionFromJson.topicId, testTopicId);
      expect(questionFromJson.question, testQuestionText);
      expect(questionFromJson.type, testType);
      expect(questionFromJson.answerIds, testAnswerIds);
      expect(questionFromJson.explanation, testExplanation);
    });

    test(
      'fromJson correctly deserializes JSON map without explanation (null)',
      () {
        // Arrange: testJsonWithoutExplanation is defined above

        // Act
        final questionFromJson = Question.fromJson(testJsonWithoutExplanation);

        // Assert
        expect(questionFromJson.id, 'q-no-exp-789');
        expect(questionFromJson.topicId, testTopicId);
        expect(questionFromJson.type, QuestionType.multipleChoice);
        expect(questionFromJson.explanation, isNull);
      },
    );

    test('toJson correctly serializes object with explanation', () {
      // Arrange: testQuestion is defined above

      // Act
      final jsonOutput = testQuestion.toJson();

      // Assert
      expect(jsonOutput, equals(testJson));
    });

    test('toJson correctly serializes object without explanation (null)', () {
      // Arrange: testQuestionWithoutExplanation is defined above

      // Act
      final jsonOutput = testQuestionWithoutExplanation.toJson();

      // Assert
      expect(jsonOutput, equals(testJsonWithoutExplanation));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final question1 = Question(
        id: 'eq-id',
        topicId: 'eq-topic',
        question: 'Equal Q',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanation: 'exp',
      );
      final question2 = Question(
        id: 'eq-id',
        topicId: 'eq-topic',
        question: 'Equal Q',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanation: 'exp',
      );

      // Act & Assert
      expect(question1 == question2, isTrue);
      expect(question1.hashCode == question2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final question1 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        question: 'Different Q1',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question2 = Question(
        id: 'diff-id-2', // Different ID
        topicId: 'diff-topic',
        question: 'Different Q1',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question3 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic-other', // Different topicId
        question: 'Different Q1',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question4 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        question: 'Different Q2', // Different question text
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question5 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        question: 'Different Q1',
        type: QuestionType.multipleChoice, // Different type
        answerIds: ['a', 'b'],
      );
      final question6 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        question: 'Different Q1',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'c'], // Different answerIds
      );
      final question7 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        question: 'Different Q1',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanation: 'Added explanation', // Different explanation
      );

      // Act & Assert
      expect(question1 == question2, isFalse);
      expect(question1.hashCode == question2.hashCode, isFalse);
      expect(question1 == question3, isFalse);
      expect(question1.hashCode == question3.hashCode, isFalse);
      expect(question1 == question4, isFalse);
      expect(question1.hashCode == question4.hashCode, isFalse);
      expect(question1 == question5, isFalse);
      expect(question1.hashCode == question5.hashCode, isFalse);
      expect(question1 == question6, isFalse);
      // Note: Hashcode might collide for list changes, but equality should be false
      expect(question1 == question7, isFalse);
      expect(question1.hashCode == question7.hashCode, isFalse);
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testQuestion is defined above

      // Act
      final copiedWithId = testQuestion.copyWith(id: 'new-q-id');
      final copiedWithTopicId = testQuestion.copyWith(topicId: 'new-topic-id');
      final copiedWithQuestion = testQuestion.copyWith(
        question: 'New Question?',
      );
      final copiedWithType = testQuestion.copyWith(
        type: QuestionType.multipleChoice,
      );
      final copiedWithAnswerIds = testQuestion.copyWith(answerIds: ['new-ans']);
      final copiedWithExplanation = testQuestion.copyWith(
        explanation: 'New Explanation.',
      );
      final copiedWithNullExplanation = testQuestion.copyWith(
        explanation: null,
      );

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-q-id');
      expect(copiedWithId.topicId, testQuestion.topicId);
      expect(copiedWithId.explanation, testQuestion.explanation);

      expect(copiedWithTopicId.topicId, 'new-topic-id');
      expect(copiedWithTopicId.id, testQuestion.id);

      expect(copiedWithQuestion.question, 'New Question?');
      expect(copiedWithQuestion.id, testQuestion.id);

      expect(copiedWithType.type, QuestionType.multipleChoice);
      expect(copiedWithType.id, testQuestion.id);

      expect(copiedWithAnswerIds.answerIds, ['new-ans']);
      expect(copiedWithAnswerIds.id, testQuestion.id);

      expect(copiedWithExplanation.explanation, 'New Explanation.');
      expect(copiedWithExplanation.id, testQuestion.id);

      expect(copiedWithNullExplanation.explanation, isNull);
      expect(copiedWithNullExplanation.id, testQuestion.id);

      // Ensure original object is unchanged
      expect(testQuestion.id, testId);
      expect(testQuestion.explanation, testExplanation);
    });
  });
}
