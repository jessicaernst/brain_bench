import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'quiz_answers_notifier.dart';

part 'quiz_result_notifier.g.dart';

final Logger _logger = Logger('QuizResultNotifier');

@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  @override
  QuizResultState build() {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);
    _logger.fine('QuizResultNotifier build() - initial state: $quizAnswers');
    return QuizResultState(
      selectedView: SelectedView.none,
      expandedAnswers: {},
      quizAnswers: quizAnswers,
    );
  }

  void toggleView(SelectedView newView, WidgetRef ref) {
    _logger.fine('toggleView called with newView: $newView');
    if (state.selectedView != SelectedView.none &&
        state.selectedView == newView) {
      // If we're currently in correct/incorrect and we tap the same button, go to none
      _logger.info('Toggling to SelectedView.none');
      state =
          state.copyWith(selectedView: SelectedView.none, expandedAnswers: {});
    } else {
      // We make sure to clear the expanded answers first.
      state = state.copyWith(expandedAnswers: {});
      _logger.info('Toggling view to: $newView, clearing expanded answers');
      // Wait for animation (~300ms), then switch view
      Future.delayed(const Duration(milliseconds: 300), () {
        state = state.copyWith(selectedView: newView);
        _logger.fine('View toggled to: $newView');
      });
    }
  }

  void toggleExplanation(String questionId) {
    _logger.fine('toggleExplanation called for questionId: $questionId');
    final newExpandedAnswers = {...state.expandedAnswers};
    if (newExpandedAnswers.contains(questionId)) {
      newExpandedAnswers.remove(questionId);
      _logger.info('Removed questionId $questionId from expandedAnswers');
    } else {
      newExpandedAnswers.add(questionId);
      _logger.info('Added questionId $questionId to expandedAnswers');
    }
    state = state.copyWith(expandedAnswers: newExpandedAnswers);
  }

  List<QuizAnswer> getFilteredAnswers() {
    _logger.fine(
        'getFilteredAnswers called with current selectedView: ${state.selectedView}');
    if (state.selectedView == SelectedView.none) {
      _logger.info('Returning empty list because selectedView is none');
    } else if (state.selectedView == SelectedView.correct) {
      _logger.info('Filtering for correct answers');
    } else {
      _logger.info('Filtering for incorrect answers');
    }
    final List<QuizAnswer> filteredAnswers =
        state.selectedView == SelectedView.none
            ? []
            : state.selectedView == SelectedView.correct
                ? state.quizAnswers
                    .where((answer) => answer.incorrectAnswers.isEmpty)
                    .toList()
                : state.quizAnswers
                    .where((answer) => answer.incorrectAnswers.isNotEmpty)
                    .toList();
    _logger.fine('Returning filteredAnswers: ${filteredAnswers.length}');
    return filteredAnswers;
  }

  // Helper method to check if there are any correct answers.
  bool hasCorrectAnswers() {
    _logger.fine('hasCorrectAnswers called');
    final bool result =
        state.quizAnswers.any((answer) => answer.incorrectAnswers.isEmpty);
    _logger.info('hasCorrectAnswers returning: $result');
    return result;
  }

  // Helper method to check if there are any incorrect answers.
  bool hasIncorrectAnswers() {
    _logger.fine('hasIncorrectAnswers called');
    final bool result =
        state.quizAnswers.any((answer) => answer.incorrectAnswers.isNotEmpty);
    _logger.info('hasIncorrectAnswers returning: $result');
    return result;
  }
}

enum SelectedView { none, correct, incorrect }
