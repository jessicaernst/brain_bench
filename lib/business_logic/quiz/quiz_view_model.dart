import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_view_model.g.dart';

Logger _logger = Logger('QuizViewModel');

@riverpod
class QuizViewModel extends _$QuizViewModel {
  @override
  QuizState build() {
    _logger.info('QuizViewModel initialized with initial state.');
    return QuizState.initial();
  }

  /// Check the number of correct answers based on the user's selections
  void checkAnswers(WidgetRef ref) {
    final answers = ref.read(answersNotifierProvider);

    int correctCount = 0;

    // Count correct answers where `isSelected` matches `isCorrect`
    for (var answer in answers) {
      if (answer.isSelected && answer.isCorrect) {
        correctCount++;
        _logger.fine('Correct answer selected: ${answer.id}');
      }
    }

    // Update the state with the number of correct answers
    state = state.copyWith(correctAnswers: correctCount);

    _logger.info('Checked answers: $correctCount correct answers.');
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
  final int correctAnswers;

  QuizState({required this.correctAnswers});

  /// Create the initial state with 0 correct answers
  factory QuizState.initial() => QuizState(correctAnswers: 0);

  /// Copy the current state with optional updated properties
  QuizState copyWith({int? correctAnswers}) {
    return QuizState(correctAnswers: correctAnswers ?? this.correctAnswers);
  }
}
