import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:brain_bench/data/models/result.dart';
import 'package:brain_bench/data/providers/results/result_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'quiz_answers_notifier.dart';

part 'quiz_result_notifier.g.dart';

/// Logger instance for the QuizResultNotifier class.
final Logger _logger = Logger('QuizResultNotifier');

/// A Riverpod notifier that manages the state of the quiz result page.
///
/// This notifier is responsible for:
/// - Managing the selected view (none, correct, incorrect).
/// - Managing the expanded answers.
/// - Providing a filtered list of answers based on the selected view.
/// - Calculating the total possible points, user points, and percentage.
/// - Determining if the quiz was passed.
/// - Saving the quiz result to the mock database.
/// - Marking a topic as done in the mock database.
@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  /// Builds the initial state of the notifier.
  ///
  /// The initial state is set to:
  /// - `selectedView`: `SelectedView.none`
  /// - `expandedAnswers`: An empty set.
  /// - `quizAnswers`: The list of quiz answers from the `quizAnswersNotifierProvider`.
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

  /// Toggles the selected view between `none`, `correct`, and `incorrect`.
  ///
  /// If the current view is not `none` and the new view is the same as the
  /// current view, the view is toggled to `none`. Otherwise, the view is
  /// toggled to the new view.
  ///
  /// Parameters:
  ///   - [newView]: The new view to toggle to.
  ///   - [ref]: The `WidgetRef` to access other providers.
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

  /// Toggles the explanation for a given question.
  ///
  /// If the explanation for the question is already expanded, it is collapsed.
  /// Otherwise, it is expanded.
  ///
  /// Parameters:
  ///   - [questionId]: The ID of the question to toggle the explanation for.
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

  /// Returns a filtered list of answers based on the selected view.
  ///
  /// If the selected view is `none`, an empty list is returned. If the
  /// selected view is `correct`, only correct answers are returned. If the
  /// selected view is `incorrect`, only incorrect answers are returned.
  ///
  /// Returns:
  ///   A list of [QuizAnswer] objects.
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

  /// Checks if there are any correct answers.
  ///
  /// Returns:
  ///   `true` if there are any correct answers, `false` otherwise.
  bool hasCorrectAnswers() {
    _logger.fine('hasCorrectAnswers called');
    final bool result = state.quizAnswers
        .any((answer) => answer.pointsEarned == answer.possiblePoints);
    _logger.info('hasCorrectAnswers returning: $result');
    return result;
  }

  /// Checks if there are any incorrect answers.
  ///
  /// Returns:
  ///   `true` if there are any incorrect answers, `false` otherwise.
  bool hasIncorrectAnswers() {
    _logger.fine('hasIncorrectAnswers called');
    final bool result = state.quizAnswers
        .any((answer) => answer.pointsEarned != answer.possiblePoints);
    _logger.info('hasIncorrectAnswers returning: $result');
    return result;
  }

  /// Calculates the total possible points for the quiz.
  ///
  /// Returns:
  ///   The total possible points.
  int calculateTotalPossiblePoints() {
    _logger.fine('calculateTotalPossiblePoints called');
    final total = state.quizAnswers
        .fold<int>(0, (sum, answer) => sum + answer.possiblePoints);
    _logger.info('calculateTotalPossiblePoints returning: $total');
    return total;
  }

  /// Calculates the user's points for the quiz.
  ///
  /// Returns:
  ///   The user's points.
  int calculateUserPoints() {
    _logger.fine('calculateUserPoints called');
    final userPoints = state.quizAnswers
        .fold<int>(0, (sum, answer) => sum + answer.pointsEarned);
    _logger.info('calculateUserPoints returning: $userPoints');
    return userPoints;
  }

  /// Calculates the percentage of correct answers.
  ///
  /// Returns:
  ///   The percentage of correct answers.
  double calculatePercentage() {
    _logger.fine('calculatePercentage called');
    final total = calculateTotalPossiblePoints();
    if (total == 0) return 0.0;
    final userPoints = calculateUserPoints();
    final percentage = (userPoints / total) * 100;
    _logger.info('calculatePercentage returning: $percentage');
    return percentage;
  }

  /// Determines if the quiz was passed.
  ///
  /// Returns:
  ///   `true` if the quiz was passed, `false` otherwise.
  bool isQuizPassed() {
    _logger.fine('isQuizPassed called');
    final percentage = calculatePercentage();
    final isPassed = percentage >= 60.0;
    _logger.info('isQuizPassed returning: $isPassed');
    return isPassed;
  }

  /// Saves the quiz result to the mock database.
  ///
  /// This method creates a [Result] object with the current quiz data and
  /// saves it using the `saveResultNotifierProvider`.
  ///
  /// Parameters:
  ///   - [categoryId]: The ID of the category the quiz belongs to.
  ///   - [topicId]: The ID of the topic the quiz belongs to.
  ///   - [userId]: The ID of the user who took the quiz.
  ///   - [ref]: The `WidgetRef` to access other providers.
  Future<void> saveQuizResult(
      String categoryId, String topicId, String userId, WidgetRef ref) async {
    _logger.info(
        'saveQuizResult() called for categoryId: $categoryId, topicId: $topicId');
    final result = Result.create(
        categoryId: categoryId,
        topicId: topicId,
        correct: calculateUserPoints(),
        total: calculateTotalPossiblePoints(),
        score: calculatePercentage(),
        quizAnswers: state.quizAnswers,
        userId: userId);
    await ref.read(saveResultNotifierProvider.notifier).saveResult(result);
    _logger.info('Quiz result saved successfully.');
  }

  /// Marks a topic as done in the mock database.
  ///
  /// This method uses the `saveResultNotifierProvider` to mark a
  /// topic as done.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to mark as done.
  ///   - [ref]: The `WidgetRef` to access other providers.
  Future<void> markTopicAsDone(String topicId, WidgetRef ref) async {
    _logger.info('markTopicAsDone() called for topicId: $topicId');
    await ref
        .read(saveResultNotifierProvider.notifier)
        .markTopicAsDone(topicId);
    _logger.info('Topic $topicId marked as done.');
  }
}

/// Enum representing the selected view on the quiz result page.
enum SelectedView { none, correct, incorrect }
