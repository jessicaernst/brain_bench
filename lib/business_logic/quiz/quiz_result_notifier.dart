import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'quiz_answers_notifier.dart';

part 'quiz_result_notifier.g.dart';

final Logger _logger = Logger('QuizResultNotifier');

const Duration _kExpansionAnimationDuration = Duration(milliseconds: 200);

/// A Riverpod notifier that manages the state of the quiz result page.
///
/// This notifier is responsible for:
/// - Managing the selected view (none, correct, incorrect).
/// - Managing the expanded answers.
/// - Providing a filtered list of answers based on the selected view.
/// - Calculating the total possible points, user points, and percentage.
/// - Determining if the quiz was passed.
/// - Saving the quiz result to the database.
/// - Marking a topic as done in the database.
@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  /// Builds the initial state of the notifier.
  @override
  QuizResultState build() {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);
    _logger.fine(
        'QuizResultNotifier build() - initial state: ${quizAnswers.length} answers');
    return QuizResultState(
      selectedView: SelectedView.none,
      expandedAnswers: {},
      quizAnswers: quizAnswers,
    );
  }

  // --- UI Interaction Methods ---

  /// Toggles the selected view between `none`, `correct`, and `incorrect`.
  ///
  /// When switching between 'correct' and 'incorrect', it first collapses
  /// the current view, waits for the animation, then switches the view.
  ///
  /// Parameters:
  ///   - [newView]: The new view to toggle to.
  void toggleView(SelectedView newView) {
    _logger.fine('toggleView called with newView: $newView');

    final currentView = state.selectedView;

    if (currentView != SelectedView.none && currentView == newView) {
      // --- Case 1: Same button pressed again -> Switch to 'none' ---
      _logger.info('Toggling OFF view: $currentView -> none');
      state =
          state.copyWith(selectedView: SelectedView.none, expandedAnswers: {});
    } else if (currentView != SelectedView.none && currentView != newView) {
      // --- Case 2: Switch between 'correct' and 'incorrect' ---
      _logger.info('Switching view: $currentView -> $newView');

      final viewBeingSwitchedFrom = currentView;

      _logger.fine('Switch Step 1: Clearing expanded answers for $currentView');

      Future.delayed(_kExpansionAnimationDuration, () {
        try {
          // Use FINEST for very detailed debug logs inside async callback
          _logger.finest('--- INSIDE FUTURE.DELAYED CALLBACK ---');
          _logger.finest('Current state.selectedView: ${state.selectedView}');
          _logger.finest(
              'Current state.expandedAnswers.isEmpty: ${state.expandedAnswers.isEmpty}');
          _logger
              .finest('Captured viewBeingSwitchedFrom: $viewBeingSwitchedFrom');
          _logger.finest('Captured newView: $newView');

          if (state.expandedAnswers.isEmpty &&
              state.selectedView == viewBeingSwitchedFrom) {
            _logger.finest('CONDITION TRUE: Setting selectedView to $newView');
            state = state.copyWith(selectedView: newView);
            _logger.finest('STATE SET to: ${state.selectedView}');
          } else {
            _logger.finest('CONDITION FALSE: Skipped setting view to $newView');
            if (state.expandedAnswers.isNotEmpty) {
              _logger.warning('Reason: expandedAnswers was NOT empty.');
            }
            if (state.selectedView != viewBeingSwitchedFrom) {
              _logger.warning(
                  'Reason: state.selectedView (${state.selectedView}) != viewBeingSwitchedFrom ($viewBeingSwitchedFrom)');
            }
          }
        } catch (e, s) {
          _logger.severe(
              '--- CATCH BLOCK EXECUTED in Future.delayed ---', e, s);
        }
      });
    } else {
      // --- Case 3: Switch from 'none' to 'correct' or 'incorrect' ---
      _logger.info('Switching view: none -> $newView');
      state = state.copyWith(
          selectedView: newView,
          expandedAnswers: {} // Ensure it starts collapsed
          );
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
        'getFilteredAnswers called with current selectedView: ${state.selectedView}');
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
      String categoryId, String topicId, String userId) async {
    _logger.info(
        'Attempting to save quiz result for categoryId: $categoryId, topicId: $topicId');
    try {
      final result = Result.create(
          categoryId: categoryId,
          topicId: topicId,
          correct: calculateUserPoints(),
          total: calculateTotalPossiblePoints(),
          score: calculatePercentage(),
          isPassed: isQuizPassed(),
          quizAnswers: state.quizAnswers,
          userId: userId);

      await ref.read(saveResultNotifierProvider.notifier).saveResult(result);
      _logger.info('✅ Quiz result saved successfully.');
    } catch (e, s) {
      _logger.severe('❌ Error saving quiz result: $e', e, s);
      // Consider rethrowing if the caller needs to handle this failure.
      // rethrow;
    }
  }

  Future<void> markTopicAsDone(String topicId, String categoryId) async {
    _logger.info(
        'Attempting to mark topic $topicId as done in category $categoryId');
    AppUser? user;
    List<Topic>? topics;
    QuizMockDatabaseRepository? repo;
    try {
      user = await _fetchCurrentUser();
      repo = await _fetchRepository();
      topics = await _fetchCategoryTopics(categoryId);
    } catch (e, s) {
      _logger.severe(
          '❌ Error fetching prerequisites for markTopicAsDone: $e', e, s);
      rethrow;
    }

    try {
      final updatedTopicDoneMap =
          _updateTopicCompletionStatus(user, categoryId, topicId);
      final progress = _calculateCategoryProgress(
          topics, updatedTopicDoneMap[categoryId] ?? {});
      _logger.fine(
          'Calculated progress for category $categoryId: ${(progress * 100).toStringAsFixed(1)}%');

      final userWithProgress = user.copyWith(
        isTopicDone: updatedTopicDoneMap,
        categoryProgress: {
          ...user.categoryProgress,
          categoryId: progress,
        },
      );
      await repo.updateUser(userWithProgress);
      ref.invalidate(currentUserModelProvider);

      _logger.info('✅ Topic $topicId marked as done for category $categoryId.');
      _logger.info(
          '✅ Progress for $categoryId: ${(progress * 100).toStringAsFixed(1)}%');
    } catch (e, s) {
      _logger.severe('❌ Error updating user data in markTopicAsDone: $e', e, s);
      rethrow;
    }
  }

  // --- Private Helper Functions ---

  Future<AppUser> _fetchCurrentUser() async {
    _logger.fine('Attempting to fetch current user...');
    try {
      final user = await ref.read(currentUserModelProvider.future);
      if (user == null) {
        _logger.warning(
            '⚠️ Cannot proceed: User fetch returned null after await.');
        throw Exception('User not found');
      }
      _logger.fine('Fetched current user successfully: ${user.id}');
      return user;
    } catch (e, s) {
      _logger.warning('⚠️ Cannot proceed: Error fetching user: $e', e, s);
      throw Exception('User not found');
    }
  }

  Future<QuizMockDatabaseRepository> _fetchRepository() async {
    final repo = await ref.read(quizMockDatabaseRepositoryProvider.future);
    _logger.fine('Fetched database repository instance.');
    return repo;
  }

  Future<List<Topic>> _fetchCategoryTopics(String categoryId) async {
    final topics = await ref.read(topicsProvider(categoryId, 'en').future);
    _logger.fine('Fetched ${topics.length} topics for category $categoryId.');
    return topics;
  }

  Map<String, Map<String, bool>> _updateTopicCompletionStatus(
      AppUser user, String categoryId, String topicId) {
    final updatedMap = Map<String, Map<String, bool>>.from(user.isTopicDone.map(
      (key, value) => MapEntry(key, Map<String, bool>.from(value)),
    ));
    final categoryMap = updatedMap.putIfAbsent(categoryId, () => {});
    categoryMap[topicId] = true;
    _logger.finer('Updated topic completion status for $categoryId - $topicId');
    return updatedMap;
  }

  List<QuizAnswer> _filterAnswersByView(
      List<QuizAnswer> answers, SelectedView view) {
    switch (view) {
      case SelectedView.none:
        _logger.finer(
            'Filtering: Returning empty list because selectedView is none');
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

  double _calculateCategoryProgress(
      List<Topic> categoryTopics, Map<String, bool> doneTopicsMap) {
    if (categoryTopics.isEmpty) return 0.0;
    final passedTopicsCount =
        categoryTopics.where((t) => doneTopicsMap[t.id] == true).length;
    return passedTopicsCount / categoryTopics.length;
  }
}

/// Enum representing the selected view on the quiz result page.
enum SelectedView { none, correct, incorrect }
