import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

// Helper to create mock QuizAnswer objects
QuizAnswer _createMockQuizAnswer(String id,
    {int points = 1, int possible = 1}) {
  return QuizAnswer(
    id: id,
    topicId: 't1',
    categoryId: 'c1',
    questionId: 'q$id',
    questionText: 'Question for $id',
    givenAnswers: ['given_$id'],
    correctAnswers: ['correct_$id'],
    incorrectAnswers: [], // Keep simple for this test
    allAnswers: ['given_$id', 'correct_$id', 'other_$id'],
    explanation: 'Explanation for $id',
    pointsEarned: points,
    possiblePoints: possible,
  );
}

void main() {
  group('Result Model', () {
    // --- Test Data ---
    const testId = 'res-id-789';
    const testUserId = 'user-123';
    const testTopicId = 'topic-abc';
    const testCategoryId = 'cat-xyz';
    const testCorrect = 8;
    const testTotal = 10;
    const testScore = 80.0;
    const testIsPassed = true;
    final testTimestamp = DateTime(2023, 10, 27, 10, 30, 0);
    final testQuizAnswers = [
      _createMockQuizAnswer('qa1'),
      _createMockQuizAnswer('qa2', points: 0),
    ];

    // Instance using default factory
    final testResult = Result(
      id: testId,
      userId: testUserId,
      topicId: testTopicId,
      categoryId: testCategoryId,
      correct: testCorrect,
      total: testTotal,
      score: testScore,
      isPassed: testIsPassed,
      timestamp: testTimestamp,
      quizAnswers: testQuizAnswers,
    );

    // JSON representation
    final testJson = {
      'id': testId,
      'userId': testUserId,
      'topicId': testTopicId,
      'categoryId': testCategoryId,
      'correct': testCorrect,
      'total': testTotal,
      'score': testScore,
      'isPassed': testIsPassed,
      'timestamp': testTimestamp
          .toIso8601String(), // Timestamps are serialized as ISO strings
      'quizAnswers': testQuizAnswers
          .map((qa) => qa.toJson())
          .toList(), // List of JSON objects
    };

    // --- Tests ---

    test('Default factory constructor creates instance with correct values',
        () {
      // Arrange & Act: testResult is already created

      // Assert
      expect(testResult.id, testId);
      expect(testResult.userId, testUserId);
      expect(testResult.topicId, testTopicId);
      expect(testResult.categoryId, testCategoryId);
      expect(testResult.correct, testCorrect);
      expect(testResult.total, testTotal);
      expect(testResult.score, testScore);
      expect(testResult.isPassed, testIsPassed);
      expect(testResult.timestamp, testTimestamp);
      expect(testResult.quizAnswers, testQuizAnswers);
    });

    test(
        'Result.create factory generates UUID, sets current timestamp, and assigns properties',
        () {
      // Arrange
      const createUserId = 'user-create';
      const createTopicId = 'topic-create';
      const createCategoryId = 'cat-create';
      const createCorrect = 5;
      const createTotal = 8;
      const createScore = 62.5;
      const createIsPassed = false;
      final createQuizAnswers = [_createMockQuizAnswer('qa-create')];
      final timeBefore = DateTime.now();

      // Act
      final createdResult = Result.create(
        userId: createUserId,
        topicId: createTopicId,
        categoryId: createCategoryId,
        correct: createCorrect,
        total: createTotal,
        score: createScore,
        isPassed: createIsPassed,
        quizAnswers: createQuizAnswers,
      );
      final timeAfter = DateTime.now();

      // Assert
      expect(createdResult.id, isNotEmpty);
      expect(
          Uuid.isValidUUID(
              fromString: createdResult.id,
              validationMode: ValidationMode.strictRFC4122),
          isTrue);
      expect(createdResult.userId, createUserId);
      expect(createdResult.topicId, createTopicId);
      expect(createdResult.categoryId, createCategoryId);
      expect(createdResult.correct, createCorrect);
      expect(createdResult.total, createTotal);
      expect(createdResult.score, createScore);
      expect(createdResult.isPassed, createIsPassed);
      expect(createdResult.quizAnswers, createQuizAnswers);
      // Check timestamp is within the creation window
      expect(
          createdResult.timestamp.isAfter(timeBefore) ||
              createdResult.timestamp.isAtSameMomentAs(timeBefore),
          isTrue);
      expect(
          createdResult.timestamp.isBefore(timeAfter) ||
              createdResult.timestamp.isAtSameMomentAs(timeAfter),
          isTrue);
    });

    test('fromJson correctly deserializes JSON map', () {
      // Arrange: testJson is defined above

      // Act
      final resultFromJson = Result.fromJson(testJson);

      // Assert
      // Use field-by-field comparison due to potential object identity differences in lists
      expect(resultFromJson.id, testResult.id);
      expect(resultFromJson.userId, testResult.userId);
      expect(resultFromJson.topicId, testResult.topicId);
      expect(resultFromJson.categoryId, testResult.categoryId);
      expect(resultFromJson.correct, testResult.correct);
      expect(resultFromJson.total, testResult.total);
      expect(resultFromJson.score, testResult.score);
      expect(resultFromJson.isPassed, testResult.isPassed);
      expect(resultFromJson.timestamp, testResult.timestamp);
      // Compare lists element by element
      expect(resultFromJson.quizAnswers.length, testResult.quizAnswers.length);
      for (int i = 0; i < resultFromJson.quizAnswers.length; i++) {
        expect(resultFromJson.quizAnswers[i], testResult.quizAnswers[i]);
      }
      // Or simply use deep equality check provided by freezed
      expect(resultFromJson, equals(testResult));
    });

    test('toJson correctly serializes object', () {
      // Arrange: testResult is defined above

      // Act
      final jsonOutput = testResult.toJson();

      // Assert
      expect(jsonOutput, equals(testJson));
    });

    test('Equality operator (==) works correctly for identical instances', () {
      // Arrange
      final result1 = Result(
        id: 'eq-id',
        userId: 'u',
        topicId: 't',
        categoryId: 'c',
        correct: 1,
        total: 1,
        score: 100.0,
        isPassed: true,
        timestamp: testTimestamp,
        quizAnswers: testQuizAnswers,
      );
      final result2 = Result(
        id: 'eq-id',
        userId: 'u',
        topicId: 't',
        categoryId: 'c',
        correct: 1,
        total: 1,
        score: 100.0,
        isPassed: true,
        timestamp: testTimestamp,
        quizAnswers: testQuizAnswers,
      );

      // Act & Assert
      expect(result1 == result2, isTrue);
      expect(result1.hashCode == result2.hashCode, isTrue);
    });

    test('Equality operator (==) works correctly for different instances', () {
      // Arrange
      final result1 = Result(
        id: 'diff-id-1',
        userId: 'u1',
        topicId: 't1',
        categoryId: 'c1',
        correct: 1,
        total: 2,
        score: 50.0,
        isPassed: false,
        timestamp: testTimestamp,
        quizAnswers: [],
      );
      final result2 = result1.copyWith(id: 'diff-id-2'); // Different ID
      final result3 = result1.copyWith(userId: 'u2'); // Different userId
      final result4 = result1.copyWith(score: 60.0); // Different score
      final result5 = result1.copyWith(isPassed: true); // Different isPassed
      final result6 =
          result1.copyWith(timestamp: DateTime.now()); // Different timestamp
      final result7 = result1.copyWith(
          quizAnswers: [_createMockQuizAnswer('qa-diff')]); // Different answers

      // Act & Assert
      expect(result1 == result2, isFalse);
      expect(result1.hashCode == result2.hashCode, isFalse);
      expect(result1 == result3, isFalse);
      expect(result1.hashCode == result3.hashCode, isFalse);
      expect(result1 == result4, isFalse);
      expect(result1.hashCode == result4.hashCode, isFalse);
      expect(result1 == result5, isFalse);
      expect(result1.hashCode == result5.hashCode, isFalse);
      expect(result1 == result6, isFalse);
      expect(result1.hashCode == result6.hashCode, isFalse);
      expect(result1 == result7, isFalse);
      // Hash code might collide with list changes, but equality must be false
    });

    test('copyWith creates a new instance with updated values', () {
      // Arrange: testResult is defined above

      // Act
      final copiedWithId = testResult.copyWith(id: 'new-res-id');
      final copiedWithScore = testResult.copyWith(score: 90.0, correct: 9);
      final copiedWithIsPassed = testResult.copyWith(isPassed: false);
      final copiedWithAnswers =
          testResult.copyWith(quizAnswers: [_createMockQuizAnswer('qa-new')]);

      // Assert
      // Check updated value and that others remain the same
      expect(copiedWithId.id, 'new-res-id');
      expect(copiedWithId.userId, testResult.userId);
      expect(copiedWithId.score, testResult.score);

      expect(copiedWithScore.score, 90.0);
      expect(copiedWithScore.correct, 9);
      expect(copiedWithScore.id, testResult.id);
      expect(copiedWithScore.total, testResult.total);

      expect(copiedWithIsPassed.isPassed, false);
      expect(copiedWithIsPassed.id, testResult.id);

      expect(copiedWithAnswers.quizAnswers.length, 1);
      expect(copiedWithAnswers.quizAnswers.first.id, 'qa-new');
      expect(copiedWithAnswers.id, testResult.id);
      expect(copiedWithAnswers.correct, testResult.correct);

      // Ensure original object is unchanged
      expect(testResult.id, testId);
      expect(testResult.score, testScore);
      expect(testResult.quizAnswers.length, 2);
    });
  });
}
