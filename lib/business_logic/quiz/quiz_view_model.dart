import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_view_model.g.dart';

Logger _logger = Logger('QuizViewModel');

@Riverpod(keepAlive: true)
class QuizViewModel extends _$QuizViewModel {
  @override
  QuizState build() {
    _logger.info(
        'QuizViewModel initialized with initial state. This should only happen once!');
    return QuizState.initial();
  }

  /// Check the user's selected answers and provide detailed feedback
  void checkAnswers(WidgetRef ref) {
    final answers = ref.read(answersNotifierProvider); // Get current answers

    // Correct answers selected by the user
    final correctAnswersSelected =
        answers.where((a) => a.isSelected && a.isCorrect).toList();

    // Incorrect answers selected by the user
    final incorrectAnswersSelected =
        answers.where((a) => a.isSelected && !a.isCorrect).toList();

    // Missed correct answers (correct answers that were not selected)
    final missedCorrectAnswers =
        answers.where((a) => !a.isSelected && a.isCorrect).toList();

    // Log the details
    _logger.info(
        '✅ Correct answers selected: ${correctAnswersSelected.map((a) => a.text).toList()}');
    _logger.info(
        '❌ Incorrect answers selected: ${incorrectAnswersSelected.map((a) => a.text).toList()}');
    _logger.info(
        '⚠️ Missed correct answers: ${missedCorrectAnswers.map((a) => a.text).toList()}');

    // Update the state with detailed information
    state = state.copyWith(
      correctAnswers: correctAnswersSelected,
      incorrectAnswers: incorrectAnswersSelected,
      missedCorrectAnswers: missedCorrectAnswers,
    );
  }

  /// Load the next question
  void loadNextQuestion(WidgetRef ref) {
    if (state.currentIndex + 1 < state.questions.length) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      _logger.info('🔄 Loading next question: Index ${state.currentIndex}');

      // Initialize answers for the next question
      final answersNotifier = ref.read(answersNotifierProvider.notifier);
      answersNotifier
          .initializeAnswers(state.questions[state.currentIndex].answers);
    } else {
      _logger.info('✅ No more questions available.');
    }
  }

  /// Set the questions for the quiz
  void setQuestions(List<Question> questions, WidgetRef ref) {
    state = state.copyWith(questions: questions, currentIndex: 0);
    _logger.info('Questions initialized. Total: ${questions.length}');
    ref
        .read(answersNotifierProvider.notifier)
        .initializeAnswers(questions.first.answers);
  }

  /// Reset the quiz by clearing all user selections
  void resetQuiz(WidgetRef ref) {
    _logger.info('Resetting the quiz and clearing all selected answers.');

    // Reset all answers' selections
    ref.read(answersNotifierProvider.notifier).resetAnswers();

    // Reset the quiz state to the initial state
    state = QuizState.initial();

    _logger.info('Quiz state reset to initial values.');
  }
}

class QuizState {
  QuizState({
    required this.questions,
    required this.currentIndex,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
  });

  final List<Question> questions;
  final int currentIndex;
  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;

  factory QuizState.initial() => QuizState(
        questions: [],
        currentIndex: 0,
        correctAnswers: [],
        incorrectAnswers: [],
        missedCorrectAnswers: [],
      );

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<Answer>? correctAnswers,
    List<Answer>? incorrectAnswers,
    List<Answer>? missedCorrectAnswers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers ?? this.missedCorrectAnswers,
    );
  }
}
