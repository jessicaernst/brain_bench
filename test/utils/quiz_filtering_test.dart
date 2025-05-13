import 'package:brain_bench/business_logic/quiz/quiz_state.dart';
import 'package:brain_bench/core/utils/quiz/quiz_filtering.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:flutter_test/flutter_test.dart';

// Helper function to create mock Answer objects
Answer _createAnswer(
  String id, {
  bool isCorrect = false,
  bool isSelected = false,
}) {
  return Answer(
    id: id,
    textDe: 'Text DE $id',
    textEn: 'Text EN $id',
    isCorrect: isCorrect,
    isSelected: isSelected,
  );
}

// Helper function to create a basic QuizState
QuizState _createQuizState({
  List<String> correct = const [],
  List<String> incorrect = const [],
  List<String> missed = const [],
  List<Question> questions = const [], // Not directly relevant but needed
  int currentIndex = 0, // Not directly relevant but needed
}) {
  return QuizState(
    questions: questions,
    currentIndex: currentIndex,
    correctAnswers: correct,
    incorrectAnswers: incorrect,
    missedCorrectAnswers: missed,
    isLoadingAnswers: false,
  );
}

void main() {
  group('filterAnswers', () {
    // Define some mock answers
    final answer1 = _createAnswer('a1', isCorrect: true);
    final answer2 = _createAnswer('a2', isCorrect: false);
    final answer3 = _createAnswer('a3', isCorrect: true);
    final answer4 = _createAnswer('a4', isCorrect: false);
    final answer5 = _createAnswer('a5', isCorrect: true);

    final allAnswersList = [answer1, answer2, answer3, answer4, answer5];

    test('should return empty lists when allCurrentAnswers is empty', () {
      // Arrange
      final quizState = _createQuizState(
        correct: ['a1'],
        incorrect: ['a2'],
        missed: ['a3'],
      );
      const List<Answer> emptyAnswers = [];

      // Act
      final result = filterAnswers(quizState, emptyAnswers);

      // Assert
      expect(result.correct, isEmpty);
      expect(result.incorrect, isEmpty);
      expect(result.missed, isEmpty);
    });

    test('should return empty lists when quizState lists are empty', () {
      // Arrange
      final quizState = _createQuizState(); // All lists empty by default

      // Act
      final result = filterAnswers(quizState, allAnswersList);

      // Assert
      expect(result.correct, isEmpty);
      expect(result.incorrect, isEmpty);
      expect(result.missed, isEmpty);
    });

    test('should correctly filter answers based on quizState IDs', () {
      // Arrange
      final quizState = _createQuizState(
        correct: ['a1', 'a5'], // answer1, answer5
        incorrect: ['a2'], // answer2
        missed: ['a3'], // answer3
      );

      // Act
      final result = filterAnswers(quizState, allAnswersList);

      // Assert
      expect(result.correct, containsAllInOrder([answer1, answer5]));
      expect(result.correct.length, 2);
      expect(result.incorrect, containsAllInOrder([answer2]));
      expect(result.incorrect.length, 1);
      expect(result.missed, containsAllInOrder([answer3]));
      expect(result.missed.length, 1);
    });

    test(
      'should return empty lists if quizState IDs do not match any answers',
      () {
        // Arrange
        final quizState = _createQuizState(
          correct: ['x1', 'x2'],
          incorrect: ['y1'],
          missed: ['z1'],
        );

        // Act
        final result = filterAnswers(quizState, allAnswersList);

        // Assert
        expect(result.correct, isEmpty);
        expect(result.incorrect, isEmpty);
        expect(result.missed, isEmpty);
      },
    );

    test('should handle only correct answers present in quizState', () {
      // Arrange
      final quizState = _createQuizState(
        correct: ['a1', 'a3'], // answer1, answer3
      );

      // Act
      final result = filterAnswers(quizState, allAnswersList);

      // Assert
      expect(result.correct, containsAllInOrder([answer1, answer3]));
      expect(result.correct.length, 2);
      expect(result.incorrect, isEmpty);
      expect(result.missed, isEmpty);
    });

    test('should handle only incorrect answers present in quizState', () {
      // Arrange
      final quizState = _createQuizState(
        incorrect: ['a2', 'a4'], // answer2, answer4
      );

      // Act
      final result = filterAnswers(quizState, allAnswersList);

      // Assert
      expect(result.correct, isEmpty);
      expect(result.incorrect, containsAllInOrder([answer2, answer4]));
      expect(result.incorrect.length, 2);
      expect(result.missed, isEmpty);
    });

    test('should handle only missed answers present in quizState', () {
      // Arrange
      final quizState = _createQuizState(
        missed: ['a3', 'a5'], // answer3, answer5
      );

      // Act
      final result = filterAnswers(quizState, allAnswersList);

      // Assert
      expect(result.correct, isEmpty);
      expect(result.incorrect, isEmpty);
      expect(result.missed, containsAllInOrder([answer3, answer5]));
      expect(result.missed.length, 2);
    });

    test(
      'should ignore answers in allCurrentAnswers not present in quizState lists',
      () {
        // Arrange
        final quizState = _createQuizState(
          correct: ['a1'], // answer1
          incorrect: ['a4'], // answer4
          // a2, a3, a5 are not mentioned in quizState lists
        );

        // Act
        final result = filterAnswers(quizState, allAnswersList);

        // Assert
        expect(result.correct, containsAllInOrder([answer1]));
        expect(result.correct.length, 1);
        expect(result.incorrect, containsAllInOrder([answer4]));
        expect(result.incorrect.length, 1);
        expect(result.missed, isEmpty);
      },
    );

    test(
      'should handle duplicate IDs in quizState lists gracefully (Set conversion)',
      () {
        // Arrange
        final quizState = _createQuizState(
          correct: ['a1', 'a1', 'a5'], // Duplicate 'a1'
          incorrect: ['a2'],
          missed: ['a3', 'a3'], // Duplicate 'a3'
        );

        // Act
        final result = filterAnswers(quizState, allAnswersList);

        // Assert
        // Duplicates in input lists are ignored due to Set conversion internally
        expect(result.correct, containsAllInOrder([answer1, answer5]));
        expect(result.correct.length, 2);
        expect(result.incorrect, containsAllInOrder([answer2]));
        expect(result.incorrect.length, 1);
        expect(result.missed, containsAllInOrder([answer3]));
        expect(result.missed.length, 1);
      },
    );
  });
}
