import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/data/models/answer.dart';
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

  /// Reset the quiz by clearing all user selections
  void resetQuiz(Ref ref) {
    _logger.info('Resetting the quiz and clearing all selected answers.');

    // Reset all answers' selections
    ref.read(answersNotifierProvider.notifier).resetAnswers();

    // Reset the quiz state to the initial state
    state = QuizState.initial();

    _logger.info('Quiz state reset to initial values.');
  }
}

class QuizState {
  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;

  QuizState({
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
  });

  /// Create the initial state with empty lists for answers
  factory QuizState.initial() => QuizState(
        correctAnswers: [],
        incorrectAnswers: [],
        missedCorrectAnswers: [],
      );

  /// Copy the current state with optional updated properties
  QuizState copyWith({
    List<Answer>? correctAnswers,
    List<Answer>? incorrectAnswers,
    List<Answer>? missedCorrectAnswers,
  }) {
    return QuizState(
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers ?? this.missedCorrectAnswers,
    );
  }
}
