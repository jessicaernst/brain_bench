import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
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
/// - Saving the quiz result to the database.
/// - Marking a topic as done in the database.
@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  /// Builds the initial state of the notifier.
  @override
  QuizResultState build() {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);
    _logger.fine(// Changed level
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
  /// Updates the state immediately. If specific animation timing is needed
  /// between clearing expansions and changing the view, it should be handled
  /// in the UI layer based on these state changes.
  ///
  /// Parameters:
  ///   - [newView]: The new view to toggle to.
  void toggleView(SelectedView newView) {
    _logger.fine('toggleView called with newView: $newView');
    if (state.selectedView != SelectedView.none &&
        state.selectedView == newView) {
      // If we're currently in correct/incorrect and we tap the same button, go to none
      _logger.info('Toggling to SelectedView.none');
      state =
          state.copyWith(selectedView: SelectedView.none, expandedAnswers: {});
    } else {
      // Update view and clear expansions simultaneously
      _logger.info('Toggling view to: $newView, clearing expanded answers');
      state = state.copyWith(
          selectedView: newView, // Set the new view
          expandedAnswers: {} // Clear expansions
          );
      // Removed Future.delayed. UI should react to state change for animations.
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

  // --- Data Access/Filtering Methods ---

  /// Returns a filtered list of answers based on the selected view.
  ///
  /// Delegates filtering logic to [_filterAnswersByView].
  ///
  /// Returns:
  ///   A list of [QuizAnswer] objects.
  List<QuizAnswer> getFilteredAnswers() {
    _logger.fine(// Changed level
        'getFilteredAnswers called with current selectedView: ${state.selectedView}');
    return _filterAnswersByView(state.quizAnswers, state.selectedView);
  }

  /// Checks if there are any correct answers.
  ///
  /// Delegates check to [_isAnswerCorrect].
  ///
  /// Returns:
  ///   `true` if there are any correct answers, `false` otherwise.
  bool hasCorrectAnswers() {
    final result = state.quizAnswers.any(_isAnswerCorrect);
    _logger.finer('hasCorrectAnswers returning: $result');
    return result;
  }

  /// Checks if there are any incorrect answers.
  ///
  /// Delegates check to [_isAnswerCorrect].
  ///
  /// Returns:
  ///   `true` if there are any incorrect answers, `false` otherwise.
  bool hasIncorrectAnswers() {
    final result = state.quizAnswers.any((a) => !_isAnswerCorrect(a));
    _logger.finer('hasIncorrectAnswers returning: $result');
    return result;
  }

  // --- Calculation Methods ---

  /// Calculates the total possible points for the quiz.
  ///
  /// Delegates calculation to [_calculateTotalPoints].
  ///
  /// Returns:
  ///   The total possible points.
  int calculateTotalPossiblePoints() {
    final total = _calculateTotalPoints(state.quizAnswers);
    _logger.finer('calculateTotalPossiblePoints returning: $total');
    return total;
  }

  /// Calculates the user's points for the quiz.
  ///
  /// Delegates calculation to [_calculateEarnedPoints].
  ///
  /// Returns:
  ///   The user's points.
  int calculateUserPoints() {
    final userPoints = _calculateEarnedPoints(state.quizAnswers);
    _logger.finer('calculateUserPoints returning: $userPoints');
    return userPoints;
  }

  /// Calculates the percentage of correct answers.
  ///
  /// Delegates calculation to [_calculatePercentageScore].
  ///
  /// Returns:
  ///   The percentage of correct answers.
  double calculatePercentage() {
    final total = calculateTotalPossiblePoints();
    final userPoints = calculateUserPoints();
    final percentage = _calculatePercentageScore(userPoints, total);
    _logger.finer('calculatePercentage returning: $percentage');
    return percentage;
  }

  /// Determines if the quiz was passed.
  ///
  /// Delegates check to [_checkIfPassed].
  ///
  /// Returns:
  ///   `true` if the quiz was passed, `false` otherwise.
  bool isQuizPassed() {
    final percentage = calculatePercentage();
    final isPassed = _checkIfPassed(percentage);
    _logger.finer('isQuizPassed returning: $isPassed');
    return isPassed;
  }

  // --- Database Interaction Methods ---

  /// Saves the quiz result to the database.
  ///
  /// This method creates a [Result] object with the current quiz data and
  /// saves it using the `saveResultNotifierProvider`. Includes error handling.
  ///
  /// Parameters:
  ///   - [categoryId]: The ID of the category the quiz belongs to.
  ///   - [topicId]: The ID of the topic the quiz belongs to.
  ///   - [userId]: The ID of the user who took the quiz.
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

      // Use the provider's own ref
      await ref.read(saveResultNotifierProvider.notifier).saveResult(result);
      _logger.info('✅ Quiz result saved successfully.');
    } catch (e, s) {
      _logger.severe('❌ Error saving quiz result: $e', e, s);
      // Optionally: Rethrow, set an error state, or notify the UI
      // Consider rethrowing if the caller needs to handle this failure:
      // rethrow;
    }
  }

  /// Marks a topic as done and updates category progress in the database.
  ///
  /// Refactored to use helper functions for clarity and testability.
  /// Includes error handling for fetching prerequisites and updating data.
  /// Rethrows errors to allow the caller (UI) to handle them.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to mark as done.
  ///   - [categoryId]: The ID of the category the topic belongs to.
  Future<void> markTopicAsDone(String topicId, String categoryId) async {
    _logger.info(
        'Attempting to mark topic $topicId as done in category $categoryId');
    AppUser? user;
    List<Topic>? topics;
    QuizMockDatabaseRepository? repo;
    // --- Step 1: Fetch prerequisites with error handling ---
    try {
      user = await _fetchCurrentUser();
      repo = await _fetchRepository();
      topics = await _fetchCategoryTopics(categoryId);
    } catch (e, s) {
      _logger.severe(
          '❌ Error fetching prerequisites for markTopicAsDone: $e', e, s);
      // Rethrow the error so the caller (UI) can handle it
      rethrow;
    }

    // --- Step 2: Update user data and save with error handling ---
    try {
      // Update completion status using helper
      final updatedTopicDoneMap =
          _updateTopicCompletionStatus(user, categoryId, topicId);

      // Calculate new progress using helper
      // Pass only the relevant category map for done topics
      final progress = _calculateCategoryProgress(
          topics, updatedTopicDoneMap[categoryId] ?? {});
      _logger.fine(// Changed level
          'Calculated progress for category $categoryId: ${(progress * 100).toStringAsFixed(1)}%');

      // Create updated user object
      final userWithProgress = user.copyWith(
        isTopicDone: updatedTopicDoneMap,
        categoryProgress: {
          ...user.categoryProgress,
          categoryId: progress,
        },
      );
      await repo.updateUser(userWithProgress);

      // Invalidate user provider ONLY on success
      ref.invalidate(currentUserModelProvider);

      _logger.info('✅ Topic $topicId marked as done for category $categoryId.');
      _logger.info(
          '✅ Progress for $categoryId: ${(progress * 100).toStringAsFixed(1)}%');
    } catch (e, s) {
      _logger.severe('❌ Error updating user data in markTopicAsDone: $e', e, s);
      // Rethrow the error so the caller (UI) can handle it
      rethrow;
    }
  }

  // --- Private Helper Functions ---

  // --- Helpers for markTopicAsDone ---

  /// Fetches the current user, throwing an error if not found.
  Future<AppUser> _fetchCurrentUser() async {
    final user = ref.read(currentUserModelProvider).valueOrNull;
    if (user == null) {
      _logger.warning('⚠️ Cannot proceed: User not found.');
      throw Exception('User not found');
    }
    _logger.fine('Fetched current user successfully.');
    return user;
  }

  /// Fetches the database repository instance.
  Future<QuizMockDatabaseRepository> _fetchRepository() async {
    // Return specific type
    // Assuming quizMockDatabaseRepositoryProvider provides the correct repo interface/instance
    final repo = await ref.read(quizMockDatabaseRepositoryProvider.future);
    _logger.fine('Fetched database repository instance.');
    // Cast or ensure the provider returns the expected type
    return repo;
  }

  /// Fetches topics for a specific category.
  Future<List<Topic>> _fetchCategoryTopics(String categoryId) async {
    // Assuming 'en' is okay or get current lang dynamically
    final topics = await ref.read(topicsProvider(categoryId, 'en').future);
    _logger.fine('Fetched ${topics.length} topics for category $categoryId.');
    return topics;
  }

  /// Creates an updated map reflecting the topic's completion status.
  Map<String, Map<String, bool>> _updateTopicCompletionStatus(
      AppUser user, String categoryId, String topicId) {
    // Create deep copies to avoid modifying the original user state directly
    final updatedMap = Map<String, Map<String, bool>>.from(user.isTopicDone.map(
      (key, value) => MapEntry(key, Map<String, bool>.from(value)),
    ));
    // Get or create the map for the specific category
    final categoryMap = updatedMap.putIfAbsent(categoryId, () => {});
    categoryMap[topicId] = true; // Mark topic as done
    // No need to putIfAbsent again, categoryMap is a reference to the map inside updatedMap
    _logger.finer('Updated topic completion status for $categoryId - $topicId');
    return updatedMap;
  }

  // --- Helpers for filtering and calculations ---

  /// Filters a list of answers based on the selected view.
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

  /// Checks if a single quiz answer is considered correct.
  bool _isAnswerCorrect(QuizAnswer answer) {
    // Correct if points earned match possible points
    return answer.pointsEarned == answer.possiblePoints;
  }

  /// Calculates the total possible points from a list of answers.
  int _calculateTotalPoints(List<QuizAnswer> answers) {
    // Sum up possible points for all answers
    return answers.fold<int>(0, (sum, answer) => sum + answer.possiblePoints);
  }

  /// Calculates the total earned points from a list of answers.
  int _calculateEarnedPoints(List<QuizAnswer> answers) {
    // Sum up earned points for all answers
    return answers.fold<int>(0, (sum, answer) => sum + answer.pointsEarned);
  }

  /// Calculates the percentage score.
  double _calculatePercentageScore(int earnedPoints, int totalPoints) {
    // Avoid division by zero
    if (totalPoints == 0) return 0.0;
    // Calculate percentage
    return (earnedPoints / totalPoints) * 100.0;
  }

  /// Checks if the percentage score meets the passing threshold (>= 60%).
  bool _checkIfPassed(double percentage) {
    // Check against threshold
    return percentage >= 60.0;
  }

  /// Calculates the progress for a category based on completed topics.
  double _calculateCategoryProgress(
      List<Topic> categoryTopics, Map<String, bool> doneTopicsMap) {
    // Avoid division by zero
    if (categoryTopics.isEmpty) return 0.0;
    // Count topics marked as done within the specific category map
    final passedTopicsCount =
        categoryTopics.where((t) => doneTopicsMap[t.id] == true).length;
    // Calculate progress ratio
    return passedTopicsCount / categoryTopics.length;
  }
}

/// Enum representing the selected view on the quiz result page.
enum SelectedView { none, correct, incorrect }
