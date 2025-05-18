import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'quiz_answers_notifier.dart';

part 'quiz_result_notifier.g.dart';

final Logger _logger = Logger('QuizResultNotifier');

/// A Riverpod notifier that manages the state of the quiz result page.
///
/// This notifier is responsible for:
/// - Managing the selected view (none, correct, incorrect).
/// - Managing the expanded answers.
/// - Providing a filtered list of answers based on the selected view.
/// - Calculating the total possible points, user points, and percentage.
/// - Determining if the quiz was passed.
/// - Saving the quiz result to the database.
@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  /// Builds the initial state of the notifier.
  // Define animation duration (should match UI animation)
  static const Duration _kAnimationDuration = Duration(milliseconds: 300);

  @override
  QuizResultState build() {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);
    _logger.fine(
      'QuizResultNotifier build() - initial state: ${quizAnswers.length} answers',
    );
    return QuizResultState(
      selectedView: SelectedView.none,
      expandedAnswers: {},
      quizAnswers: quizAnswers,
    );
  }

  // --- UI Interaction Methods ---

  /// Toggles the view between different [SelectedView]s.
  ///
  /// If the current view is the same as the new view, it collapses the view and switches to [SelectedView.none].
  /// If the current view is not [SelectedView.none] and the new view is not [SelectedView.none], it first collapses the view and then switches to the new view after a delay.
  /// If the current view is [SelectedView.none] or the new view is [SelectedView.none], it immediately switches to the new view and collapses the view.
  void toggleView(SelectedView newView) {
    _logger.fine('toggleView called with newView: $newView');
    final currentView = state.selectedView;

    if (currentView == newView) {
      _logger.fine('Toggling view OFF: $currentView -> none');
      state = state.copyWith(
        selectedView: SelectedView.none,
        expandedAnswers: {},
      );
    } else if (currentView != SelectedView.none &&
        newView != SelectedView.none) {
      // Switching between Correct and Incorrect: Collapse first, then switch view after delay
      _logger.fine('Switching view: $currentView -> $newView (with delay)');
      // Step 1: Start collapse animation
      state = state.copyWith(expandedAnswers: {});
      // Step 2: Wait for animation duration, then switch the view
      Future.delayed(_kAnimationDuration, () {
        // Check if the state is still relevant (user might have clicked again)
        if (state.selectedView == currentView &&
            state.expandedAnswers.isEmpty) {
          state = state.copyWith(selectedView: newView);
          _logger.fine('Delayed view switch complete: -> $newView');
        } else {
          _logger.fine(
            'Delayed view switch aborted (state changed during delay)',
          );
        }
      });
    } else {
      // Switching from/to 'none': Collapse and switch immediately
      _logger.fine('Toggling view ON: $currentView -> $newView');
      state = state.copyWith(selectedView: newView, expandedAnswers: {});
    }
  }

  /// Toggles the explanation for a given question.
  void toggleExplanation(String questionId) {
    _logger.fine('toggleExplanation called for questionId: $questionId');
    final newExpandedAnswers = {...state.expandedAnswers};
    if (newExpandedAnswers.contains(questionId)) {
      newExpandedAnswers.remove(questionId);
      _logger.fine('Removed questionId $questionId from expandedAnswers');
    } else {
      newExpandedAnswers.add(questionId);
      _logger.fine('Added questionId $questionId to expandedAnswers');
    }
    state = state.copyWith(expandedAnswers: newExpandedAnswers);
  }

  // --- Data Access/Filtering Methods ---

  List<QuizAnswer> getFilteredAnswers() {
    _logger.fine(
      'getFilteredAnswers called with current selectedView: ${state.selectedView}',
    );
    return _filterAnswersByView(state.quizAnswers, state.selectedView);
  }

  bool hasCorrectAnswers() {
    final result = state.quizAnswers.any(_isAnswerCorrect);
    _logger.finer('hasCorrectAnswers returning: $result');
    return result;
  }

  bool hasIncorrectAnswers() {
    final result = state.quizAnswers.any((a) => !_isAnswerCorrect(a));
    _logger.finer('hasIncorrectAnswers returning: $result');
    return result;
  }

  // --- Calculation Methods ---

  int calculateTotalPossiblePoints() {
    final total = _calculateTotalPoints(state.quizAnswers);
    _logger.finer('calculateTotalPossiblePoints returning: $total');
    return total;
  }

  int calculateUserPoints() {
    final userPoints = _calculateEarnedPoints(state.quizAnswers);
    _logger.finer('calculateUserPoints returning: $userPoints');
    return userPoints;
  }

  double calculatePercentage() {
    final total = calculateTotalPossiblePoints();
    final userPoints = calculateUserPoints();
    final percentage = _calculatePercentageScore(userPoints, total);
    _logger.finer('calculatePercentage returning: $percentage');
    return percentage;
  }

  bool isQuizPassed() {
    final percentage = calculatePercentage();
    final isPassed = _checkIfPassed(percentage);
    _logger.finer('isQuizPassed returning: $isPassed');
    return isPassed;
  }

  // --- Database Interaction Methods ---

  Future<void> saveQuizResult(
    String categoryId,
    String topicId,
    String userId,
  ) async {
    _logger.info(
      'Attempting to save quiz result for categoryId: $categoryId, topicId: $topicId',
    );
    try {
      final result = Result.create(
        categoryId: categoryId,
        topicId: topicId,
        correct: calculateUserPoints(),
        total: calculateTotalPossiblePoints(),
        score: calculatePercentage(),
        isPassed: isQuizPassed(),
        quizAnswers: state.quizAnswers,
        userId: userId,
      );

      await ref.read(saveResultNotifierProvider.notifier).saveResult(result);
      _logger.info('✅ Quiz result saved successfully.');
    } catch (e, s) {
      _logger.severe('❌ Error saving quiz result: $e', e, s);
    }
  }

  Future<void> markTopicAsDone(
    AppUser user,
    String topicId,
    String categoryId,
  ) async {
    _logger.info(
      'Attempting to mark topic $topicId as done in category $categoryId via SaveResultNotifier.',
    );

    try {
      await ref
          .read(saveResultNotifierProvider.notifier)
          .markTopicAsDone(
            topicId: topicId,
            categoryId: categoryId,
            userId: user.uid, // Pass the userId
          );
      ref.invalidate(currentUserModelProvider);
      _logger.info('✅ Topic $topicId marked as done for category $categoryId.');
    } catch (e, s) {
      _logger.severe(
        '❌ Error in markTopicAsDone for topic $topicId, category $categoryId: $e',
        e,
        s,
      );
      rethrow;
    }
  }

  /// Updates the last played category ID for the current user in the database.
  Future<void> updateLastPlayedCategory(AppUser user, String categoryId) async {
    _logger.info(
      'Attempting to update lastPlayedCategoryId to "$categoryId" for user "${user.id}".',
    );
    try {
      final userRepo = await ref.read(userRepositoryProvider.future);
      await userRepo.updateUser(
        // Use UserRepository
        user.copyWith(lastPlayedCategoryId: categoryId),
      );
      ref.invalidate(currentUserModelProvider);
      _logger.info(
        // Log with the ID of the user record that was actually updated.
        '✅ Successfully updated lastPlayedCategoryId to "$categoryId" for user "${user.id}".',
      );
    } catch (e, s) {
      _logger.severe(
        '❌ Error updating lastPlayedCategoryId for user "${user.id}": $e',
        e,
        s,
      );
      rethrow; // Re-throw the exception so the caller can handle it.
    }
  }

  // --- Private Helper Functions ---

  List<QuizAnswer> _filterAnswersByView(
    List<QuizAnswer> answers,
    SelectedView view,
  ) {
    switch (view) {
      case SelectedView.none:
        _logger.finer(
          'Filtering: Returning empty list because selectedView is none',
        );
        return [];
      case SelectedView.correct:
        _logger.finer('Filtering for correct answers');
        return answers.where(_isAnswerCorrect).toList();
      case SelectedView.incorrect:
        _logger.finer('Filtering for incorrect answers');
        return answers.where((a) => !_isAnswerCorrect(a)).toList();
    }
  }

  bool _isAnswerCorrect(QuizAnswer answer) {
    return answer.pointsEarned == answer.possiblePoints;
  }

  int _calculateTotalPoints(List<QuizAnswer> answers) {
    return answers.fold<int>(0, (sum, answer) => sum + answer.possiblePoints);
  }

  int _calculateEarnedPoints(List<QuizAnswer> answers) {
    return answers.fold<int>(0, (sum, answer) => sum + answer.pointsEarned);
  }

  double _calculatePercentageScore(int earnedPoints, int totalPoints) {
    if (totalPoints == 0) return 0.0;
    return (earnedPoints / totalPoints) * 100.0;
  }

  bool _checkIfPassed(double percentage) {
    return percentage >= 60.0;
  }
}

/// Enum representing the selected view on the quiz result page.
enum SelectedView { none, correct, incorrect }
