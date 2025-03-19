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
      return []; // Return an empty list when in SelectedView.none
    } else if (state.selectedView == SelectedView.correct) {
      _logger.info('Filtering for correct answers');
      return state.quizAnswers
          .where((answer) => answer.pointsEarned == answer.possiblePoints)
          .toList();
    } else {
      _logger.info('Filtering for incorrect answers');
      return state.quizAnswers
          .where((answer) => answer.pointsEarned != answer.possiblePoints)
          .toList();
    }
  }

  // Helper method to check if there are any correct answers.
  bool hasCorrectAnswers() {
    _logger.fine('hasCorrectAnswers called');
    final bool result = state.quizAnswers
        .any((answer) => answer.pointsEarned == answer.possiblePoints);
    _logger.info('hasCorrectAnswers returning: $result');
    return result;
  }

  // Helper method to check if there are any incorrect answers.
  bool hasIncorrectAnswers() {
    _logger.fine('hasIncorrectAnswers called');
    final bool result = state.quizAnswers
        .any((answer) => answer.pointsEarned != answer.possiblePoints);
    _logger.info('hasIncorrectAnswers returning: $result');
    return result;
  }

  // ✅ Calculate the total possible points (sum of all correct answers)
  int calculateTotalPossiblePoints() {
    _logger.fine('calculateTotalPossiblePoints called');
    final total = state.quizAnswers
        .fold<int>(0, (sum, answer) => sum + answer.possiblePoints);
    _logger.info('calculateTotalPossiblePoints returning: $total');
    return total;
  }

  // ✅ Calculate the user's points (sum of points earned)
  int calculateUserPoints() {
    _logger.fine('calculateUserPoints called');
    final userPoints = state.quizAnswers
        .fold<int>(0, (sum, answer) => sum + answer.pointsEarned);
    _logger.info('calculateUserPoints returning: $userPoints');
    return userPoints;
  }

  // ✅ Calculate the percentage
  double calculatePercentage() {
    _logger.fine('calculatePercentage called');
    final total = calculateTotalPossiblePoints();
    if (total == 0) return 0.0;
    final userPoints = calculateUserPoints();
    final percentage = (userPoints / total) * 100;
    _logger.info('calculatePercentage returning: $percentage');
    return percentage;
  }

  // ✅ Determine if the quiz was passed
  bool isQuizPassed() {
    _logger.fine('isQuizPassed called');
    final percentage = calculatePercentage();
    final isPassed = percentage >= 60.0;
    _logger.info('isQuizPassed returning: $isPassed');
    return isPassed;
  }
}

enum SelectedView { none, correct, incorrect }
