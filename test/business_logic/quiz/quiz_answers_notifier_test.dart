import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

void main() {
  // Helper function to create a ProviderContainer for testing
  ProviderContainer createContainer() {
    final container = ProviderContainer();
    // Ensure the container is disposed after each test.
    addTearDown(container.dispose);
    return container;
  }

  // Helper for deep list equality comparison
  const listEquality = DeepCollectionEquality();

  group('QuizAnswersNotifier Tests', () {
    test('Initial state should be an empty list', () {
      // Arrange
      final container = createContainer();

      // Act
      final initialState = container.read(quizAnswersNotifierProvider);

      // Assert
      expect(initialState, isA<List<QuizAnswer>>());
      expect(initialState, isEmpty);
    });

    group('addAnswer', () {
      test('should add a fully correct answer correctly', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        const questionId = 'q1';
        const topicId = 't1';
        const categoryId = 'c1';
        const questionText = 'What is Flutter?';
        const givenAnswers = ['A UI toolkit'];
        const correctAnswers = [
          'A UI toolkit'
        ]; // Expected correct answers (as per API/data source)
        const allAnswers = ['A UI toolkit', 'A backend framework'];
        const explanation = 'Flutter is a UI toolkit from Google.';
        const allCorrectAnswers = [
          'A UI toolkit'
        ]; // The definitive list of correct answers

        // Act
        notifier.addAnswer(
          questionId: questionId,
          topicId: topicId,
          categoryId: categoryId,
          questionText: questionText,
          givenAnswers: givenAnswers,
          correctAnswers: correctAnswers,
          allAnswers: allAnswers,
          explanation: explanation,
          allCorrectAnswers: allCorrectAnswers,
        );
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 1);
        final addedAnswer = state.first;
        expect(addedAnswer.questionId, questionId);
        expect(addedAnswer.topicId, topicId);
        expect(addedAnswer.categoryId, categoryId);
        expect(addedAnswer.questionText, questionText);
        expect(listEquality.equals(addedAnswer.givenAnswers, givenAnswers),
            isTrue);
        expect(listEquality.equals(addedAnswer.correctAnswers, correctAnswers),
            isTrue);
        expect(listEquality.equals(addedAnswer.allAnswers, allAnswers), isTrue);
        expect(addedAnswer.explanation, explanation);
        expect(addedAnswer.pointsEarned, 1);
        expect(addedAnswer.possiblePoints, 1);
        expect(addedAnswer.incorrectAnswers, isEmpty);
      });

      test('should add a fully incorrect answer correctly', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        const questionId = 'q2';
        const topicId = 't1';
        const categoryId = 'c1';
        const questionText = 'What is Dart?';
        const givenAnswers = ['A database'];
        const correctAnswers = ['A programming language']; // Expected correct
        const allAnswers = ['A database', 'A programming language'];
        const explanation = 'Dart is a programming language.';
        const allCorrectAnswers = [
          'A programming language'
        ]; // Definitive correct

        // Act
        notifier.addAnswer(
          questionId: questionId,
          topicId: topicId,
          categoryId: categoryId,
          questionText: questionText,
          givenAnswers: givenAnswers,
          correctAnswers: correctAnswers,
          allAnswers: allAnswers,
          explanation: explanation,
          allCorrectAnswers: allCorrectAnswers,
        );
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 1);
        final addedAnswer = state.first;
        expect(addedAnswer.questionId, questionId);
        expect(listEquality.equals(addedAnswer.givenAnswers, givenAnswers),
            isTrue);
        expect(listEquality.equals(addedAnswer.correctAnswers, correctAnswers),
            isTrue);
        expect(addedAnswer.pointsEarned, 0);
        expect(addedAnswer.possiblePoints, 1);
        expect(
            listEquality.equals(
                addedAnswer.incorrectAnswers, ['A programming language']),
            isTrue);
      });

      test(
          'should add a partially correct answer (multiple choice, multiple correct)',
          () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        const questionId = 'q3';
        const topicId = 't2';
        const categoryId = 'c2';
        const questionText = 'Select programming languages:';
        const givenAnswers = ['Dart', 'Swift'];
        const correctAnswers = ['Dart', 'Kotlin'];
        const allAnswers = ['Dart', 'Swift', 'Kotlin', 'Flutter'];
        const explanation = 'Dart and Kotlin are languages.';
        const allCorrectAnswers = ['Dart', 'Kotlin'];

        // Act
        notifier.addAnswer(
          questionId: questionId,
          topicId: topicId,
          categoryId: categoryId,
          questionText: questionText,
          givenAnswers: givenAnswers,
          correctAnswers: correctAnswers,
          allAnswers: allAnswers,
          explanation: explanation,
          allCorrectAnswers: allCorrectAnswers,
        );
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 1);
        final addedAnswer = state.first;
        expect(addedAnswer.questionId, questionId);
        expect(listEquality.equals(addedAnswer.givenAnswers, givenAnswers),
            isTrue);
        expect(listEquality.equals(addedAnswer.correctAnswers, correctAnswers),
            isTrue);
        expect(addedAnswer.pointsEarned,
            1); // Only 'Dart' was correct out of the given answers
        expect(addedAnswer.possiblePoints,
            2); // 'Dart' and 'Kotlin' are the actual correct answers
        // Missed 'Kotlin' (based on `correctAnswers` passed to addAnswer)
        expect(listEquality.equals(addedAnswer.incorrectAnswers, ['Kotlin']),
            isTrue);
      });

      test('should add an answer where user gave no answer', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        const questionId = 'q4';
        const topicId = 't1';
        const categoryId = 'c1';
        const questionText = 'Select the capital:';
        const givenAnswers = <String>[];
        const correctAnswers = ['Paris'];
        const allAnswers = ['Paris', 'London', 'Berlin'];
        const allCorrectAnswers = ['Paris'];

        // Act
        notifier.addAnswer(
          questionId: questionId,
          topicId: topicId,
          categoryId: categoryId,
          questionText: questionText,
          givenAnswers: givenAnswers,
          correctAnswers: correctAnswers,
          allAnswers: allAnswers,
          allCorrectAnswers: allCorrectAnswers,
        );
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 1);
        final addedAnswer = state.first;
        expect(addedAnswer.questionId, questionId);
        expect(listEquality.equals(addedAnswer.givenAnswers, givenAnswers),
            isTrue);
        expect(listEquality.equals(addedAnswer.correctAnswers, correctAnswers),
            isTrue);
        expect(addedAnswer.pointsEarned, 0);
        expect(addedAnswer.possiblePoints, 1);
        expect(listEquality.equals(addedAnswer.incorrectAnswers, ['Paris']),
            isTrue);
      });

      test('should add multiple answers sequentially', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);

        // Act
        // Answer 1 (Correct)
        notifier.addAnswer(
          questionId: 'q1',
          topicId: 't1',
          categoryId: 'c1',
          questionText: 'Q1',
          givenAnswers: ['A'],
          correctAnswers: ['A'],
          allAnswers: ['A', 'B'],
          allCorrectAnswers: ['A'],
        );
        // Answer 2 (Incorrect)
        notifier.addAnswer(
          questionId: 'q2',
          topicId: 't1',
          categoryId: 'c1',
          questionText: 'Q2',
          givenAnswers: ['C'],
          correctAnswers: ['D'],
          allAnswers: ['C', 'D'],
          allCorrectAnswers: ['D'],
        );
        // Answer 3 (Partial)
        notifier.addAnswer(
          questionId: 'q3',
          topicId: 't1',
          categoryId: 'c1',
          questionText: 'Q3',
          givenAnswers: ['E'],
          correctAnswers: ['E', 'F'],
          allAnswers: ['E', 'F', 'G'],
          allCorrectAnswers: ['E', 'F'],
        );

        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 3);
        // Check first answer
        expect(state[0].questionId, 'q1');
        expect(state[0].pointsEarned, 1);
        expect(state[0].possiblePoints, 1);
        expect(state[0].incorrectAnswers, isEmpty);
        // Check second answer
        expect(state[1].questionId, 'q2');
        expect(state[1].pointsEarned, 0);
        expect(state[1].possiblePoints, 1);
        expect(listEquality.equals(state[1].incorrectAnswers, ['D']), isTrue);
        // Check third answer
        expect(state[2].questionId, 'q3');
        expect(state[2].pointsEarned, 1);
        expect(state[2].possiblePoints, 2);
        expect(listEquality.equals(state[2].incorrectAnswers, ['F']), isTrue);
      });

      test('should handle case with no correct answers possible (edge case)',
          () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        const questionId = 'q5';
        const topicId = 't3';
        const categoryId = 'c3';
        const questionText = 'Impossible question';
        const givenAnswers = ['A'];
        const correctAnswers = <String>[];
        const allAnswers = ['A', 'B'];
        const allCorrectAnswers = <String>[];

        // Act
        notifier.addAnswer(
          questionId: questionId,
          topicId: topicId,
          categoryId: categoryId,
          questionText: questionText,
          givenAnswers: givenAnswers,
          correctAnswers: correctAnswers,
          allAnswers: allAnswers,
          allCorrectAnswers: allCorrectAnswers,
        );
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state.length, 1);
        final addedAnswer = state.first;
        expect(addedAnswer.questionId, questionId);
        expect(addedAnswer.pointsEarned, 0);
        expect(addedAnswer.possiblePoints, 0);
        expect(addedAnswer.incorrectAnswers, isEmpty);
      });
    });

    group('reset', () {
      test('should clear the state when it contains answers', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        // Add an answer first
        notifier.addAnswer(
          questionId: 'q1',
          topicId: 't1',
          categoryId: 'c1',
          questionText: 'Q1',
          givenAnswers: ['A'],
          correctAnswers: ['A'],
          allAnswers: ['A', 'B'],
          allCorrectAnswers: ['A'],
        );
        expect(container.read(quizAnswersNotifierProvider), isNotEmpty,
            reason: 'State should have an answer before reset');

        // Act
        notifier.reset();
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state, isEmpty);
      });

      test('should do nothing when state is already empty', () {
        // Arrange
        final container = createContainer();
        final notifier = container.read(quizAnswersNotifierProvider.notifier);
        expect(container.read(quizAnswersNotifierProvider), isEmpty,
            reason: 'State should be empty initially');

        // Act
        notifier.reset();
        final state = container.read(quizAnswersNotifierProvider);

        // Assert
        expect(state, isEmpty);
      });
    });
  });
}
