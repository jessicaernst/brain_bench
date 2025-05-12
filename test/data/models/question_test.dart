import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Question Model', () {
    // --- Test Data ---
    const testId = 'q-test-id-456';
    const testTopicId = 'topic-abc';
    const testQuestionEnText = 'What is Flutter?';
    const testQuestionDeText = 'Was ist Flutter?';
    const testType = QuestionType.singleChoice;
    final testAnswerIds = ['ans-1', 'ans-2', 'ans-3'];
    const testExplanationEnText = 'Flutter is a UI toolkit.';
    const testExplanationDeText = 'Flutter ist ein UI-Toolkit.';

    final testQuestion = Question(
      id: testId,
      topicId: testTopicId,
      questionEn: testQuestionEnText,
      questionDe: testQuestionDeText,
      type: testType,
      answerIds: testAnswerIds,
      explanationEn: testExplanationEnText,
      explanationDe: testExplanationDeText,
    );

    final testQuestionWithoutExplanation = Question(
      id: 'q-no-exp-789',
      topicId: testTopicId,
      questionEn: 'Another question EN?',
      questionDe: 'Eine andere Frage DE?',
      type: QuestionType.multipleChoice,
      answerIds: ['ans-4', 'ans-5'],
      explanationEn: null, // Explicitly null
      explanationDe: null,
    );

    final testJson = {
      'id': testId,
      'topicId': testTopicId,
      'questionEn': testQuestionEnText,
      'questionDe': testQuestionDeText,
      'type': 'singleChoice', // Enum serialized as string
      'answerIds': testAnswerIds,
      'explanationEn': testExplanationEnText,
      'explanationDe': testExplanationDeText,
    };

    final testJsonWithoutExplanation = {
      'id': 'q-no-exp-789',
      'topicId': testTopicId,
      'questionEn': 'Another question EN?',
      'questionDe': 'Eine andere Frage DE?',
      'type': 'multipleChoice',
      'answerIds': ['ans-4', 'ans-5'],
      'explanationEn': null,
      'explanationDe': null,
    };

    // --- Tests ---

    test('Default constructor creates instance with correct values', () {
      // Arrange & Act: testQuestion is already created

      // Assert
      expect(testQuestion.id, testId);
      expect(testQuestion.topicId, testTopicId);
      expect(testQuestion.questionEn, testQuestionEnText);
      expect(testQuestion.questionDe, testQuestionDeText);
      expect(testQuestion.type, testType);
      expect(testQuestion.answerIds, testAnswerIds);
      expect(testQuestion.explanationEn, testExplanationEnText);
      expect(testQuestion.explanationDe, testExplanationDeText);
    });

    test('Default constructor handles null explanation correctly', () {
      // Arrange & Act: testQuestionWithoutExplanation is already created

      // Assert
      expect(testQuestionWithoutExplanation.id, 'q-no-exp-789');
      expect(testQuestionWithoutExplanation.topicId, testTopicId);
      expect(testQuestionWithoutExplanation.explanationEn, isNull);
      expect(testQuestionWithoutExplanation.explanationDe, isNull);
    });

    test(
      'Question.create factory generates a valid UUID and sets properties',
      () {
        // Arrange
        const createTopicId = 'new-topic';
        const createQuestionEnText = 'Create question EN?';
        const createQuestionDeText = 'Erstelle Frage DE?';
        const createType = QuestionType.multipleChoice;
        final createAnswerIds = ['new-ans-1', 'new-ans-2'];
        const createExplanationEnText = 'Explanation for created question EN.';
        const createExplanationDeText = 'Erklärung für erstellte Frage DE.';

        // Act
        final createdQuestion = Question.create(
          topicId: createTopicId,
          questionEn: createQuestionEnText,
          questionDe: createQuestionDeText,
          type: createType,
          answerIds: createAnswerIds,
          explanationEn: createExplanationEnText,
          explanationDe: createExplanationDeText,
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
        expect(createdQuestion.questionEn, createQuestionEnText);
        expect(createdQuestion.questionDe, createQuestionDeText);
        expect(createdQuestion.type, createType);
        expect(createdQuestion.answerIds, createAnswerIds);
        expect(createdQuestion.explanationEn, createExplanationEnText);
        expect(createdQuestion.explanationDe, createExplanationDeText);
      },
    );

    test('Question.create factory handles null explanation', () {
      // Arrange
      const createTopicId = 'new-topic-no-exp';
      const createQuestionEnText = 'Create question no exp EN?';
      const createQuestionDeText = 'Erstelle Frage ohne Erkl. DE?';
      const createType = QuestionType.singleChoice;
      final createAnswerIds = ['new-ans-3'];

      // Act
      final createdQuestion = Question.create(
        topicId: createTopicId,
        questionEn: createQuestionEnText,
        questionDe: createQuestionDeText,
        type: createType,
        answerIds: createAnswerIds,
        // explanation is omitted, should default to null
        explanationEn: null,
        explanationDe: null,
      );

      // Assert
      expect(createdQuestion.id, isNotEmpty);
      expect(createdQuestion.topicId, createTopicId);
      expect(createdQuestion.explanationEn, isNull);
      expect(createdQuestion.explanationDe, isNull);
    });

    test('fromJson correctly deserializes JSON map with explanation', () {
      // Arrange: testJson is defined above

      // Act
      final questionFromJson = Question.fromJson(testJson);

      // Assert
      expect(questionFromJson.id, testId);
      expect(questionFromJson.topicId, testTopicId);
      expect(questionFromJson.questionEn, testQuestionEnText);
      expect(questionFromJson.questionDe, testQuestionDeText);
      expect(questionFromJson.type, testType);
      expect(questionFromJson.answerIds, testAnswerIds);
      expect(questionFromJson.explanationEn, testExplanationEnText);
      expect(questionFromJson.explanationDe, testExplanationDeText);
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
        expect(questionFromJson.explanationEn, isNull);
        expect(questionFromJson.explanationDe, isNull);
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
        questionEn: 'Equal Q EN',
        questionDe: 'Gleiche F DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanationEn: 'exp EN',
        explanationDe: 'erkl DE',
      );
      final question2 = Question(
        id: 'eq-id',
        topicId: 'eq-topic',
        questionEn: 'Equal Q EN',
        questionDe: 'Gleiche F DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanationEn: 'exp EN',
        explanationDe: 'erkl DE',
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
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question2 = Question(
        id: 'diff-id-2', // Different ID
        topicId: 'diff-topic',
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question3 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic-other', // Different topicId
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question4 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        questionEn: 'Different Q2 EN', // Different question text
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
      );
      final question5 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.multipleChoice, // Different type
        answerIds: ['a', 'b'],
      );
      final question6 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'c'], // Different answerIds
      );
      final question7 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F1 DE',
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
        explanationEn: 'Added explanation EN', // Different explanation
      );
      final question8 = Question(
        id: 'diff-id-1',
        topicId: 'diff-topic',
        questionEn: 'Different Q1 EN',
        questionDe: 'Unterschiedliche F2 DE', // Different German question
        type: QuestionType.singleChoice,
        answerIds: ['a', 'b'],
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
      expect(question1 == question8, isFalse);
      expect(question1.hashCode == question8.hashCode, isFalse);
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testQuestion is defined above

      // Act
      final copiedWithId = testQuestion.copyWith(id: 'new-q-id');
      final copiedWithTopicId = testQuestion.copyWith(topicId: 'new-topic-id');
      final copiedWithQuestionEn = testQuestion.copyWith(
        questionEn: 'New Question EN?',
      );
      final copiedWithQuestionDe = testQuestion.copyWith(
        questionDe: 'Neue Frage DE?',
      );
      final copiedWithType = testQuestion.copyWith(
        type: QuestionType.multipleChoice,
      );
      final copiedWithAnswerIds = testQuestion.copyWith(answerIds: ['new-ans']);
      final copiedWithExplanationEn = testQuestion.copyWith(
        explanationEn: 'New Explanation EN.',
      );
      final copiedWithExplanationDe = testQuestion.copyWith(
        explanationDe: 'Neue Erklärung DE.',
      );
      final copiedWithNullExplanationEn = testQuestion.copyWith(
        explanationEn: null,
      );
      final copiedWithNullExplanationDe = testQuestion.copyWith(
        explanationDe: null,
      );

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-q-id');
      expect(copiedWithId.topicId, testQuestion.topicId);
      expect(copiedWithId.explanationEn, testQuestion.explanationEn);

      expect(copiedWithTopicId.topicId, 'new-topic-id');
      expect(copiedWithTopicId.id, testQuestion.id);

      expect(copiedWithQuestionEn.questionEn, 'New Question EN?');
      expect(copiedWithQuestionEn.id, testQuestion.id);

      expect(copiedWithQuestionDe.questionDe, 'Neue Frage DE?');
      expect(copiedWithQuestionDe.id, testQuestion.id);

      expect(copiedWithType.type, QuestionType.multipleChoice);
      expect(copiedWithType.id, testQuestion.id);

      expect(copiedWithAnswerIds.answerIds, ['new-ans']);
      expect(copiedWithAnswerIds.id, testQuestion.id);

      expect(copiedWithExplanationEn.explanationEn, 'New Explanation EN.');
      expect(copiedWithExplanationEn.id, testQuestion.id);

      expect(copiedWithExplanationDe.explanationDe, 'Neue Erklärung DE.');
      expect(copiedWithExplanationDe.id, testQuestion.id);

      expect(copiedWithNullExplanationEn.explanationEn, isNull);
      expect(copiedWithNullExplanationEn.id, testQuestion.id);

      expect(copiedWithNullExplanationDe.explanationDe, isNull);
      expect(copiedWithNullExplanationDe.id, testQuestion.id);

      // Ensure original object is unchanged
      expect(testQuestion.id, testId);
      expect(testQuestion.explanationEn, testExplanationEnText);
    });
  });
}
