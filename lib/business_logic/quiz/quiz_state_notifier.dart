import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answer_evaluator.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_state_notifier.g.dart';

final Logger _logger = Logger('QuizViewModel');

@Riverpod(keepAlive: true)
class QuizStateNotifier extends _$QuizStateNotifier {
  @override
  QuizState build() {
    _logger.info('QuizViewModel initialized.');
    return QuizState.initial();
  }

  /// Fetches answers for the given IDs and updates the AnswersNotifier.
  /// This method assumes the caller has set isLoadingAnswers = true.
  /// It will set isLoadingAnswers = false upon completion or error.
  Future<void> _fetchAndSetAnswers(
      List<String> answerIds, String languageCode, String questionId) async {
    // Caller should have set isLoadingAnswers = true
    final repositoryRead = ref.read(quizMockDatabaseRepositoryProvider.future);
    try {
      final repository = await repositoryRead;
      _logger.fine(
          'Fetching answers for question ID: $questionId with IDs: $answerIds');
      final List<Answer> answers =
          await repository.getAnswers(answerIds, languageCode);

      if (answers.isNotEmpty) {
        ref.read(answersNotifierProvider.notifier).initializeAnswers(answers);
        _logger.fine(
            'Answers loaded for question ID $questionId (${answers.length}).');
      } else {
        _logger.warning(
            '⚠️ Failed to load any answers for question ID: $questionId with IDs: $answerIds');
        ref.read(answersNotifierProvider.notifier).resetAnswers();
      }
    } catch (e, s) {
      _logger.severe(
          '❌ Error fetching answers for question ID $questionId: $e', e, s);
      try {
        // Attempt to reset answers even on error
        ref.read(answersNotifierProvider.notifier).resetAnswers();
      } catch (disposeError) {
        _logger.warning(
            'ViewModel potentially disposed before error handling could reset answers: $disposeError');
      }
    } finally {
      // Set loading state to false
      try {
        state = state.copyWith(isLoadingAnswers: false);
        _logger.fine('Set isLoadingAnswers = false for question $questionId');
      } catch (e) {
        _logger.warning(
            'Failed to set isLoadingAnswers to false, provider might be disposed: $e');
      }
    }
  }

  /// Initializes the quiz if not already initialized.
  Future<void> initializeQuizIfNeeded(
      List<Question> questions, String languageCode) async {
    if (state.questions.isNotEmpty || questions.isEmpty) {
      if (questions.isEmpty) {
        _logger.warning(
            '⚠️ initializeQuizIfNeeded called with empty questions list.');
      } else {
        _logger.fine('Quiz already initialized, skipping initialization.');
      }
      return;
    }

    _logger.fine('Initializing quiz...');
    // Set initial state (index 0) and mark as loading answers
    state = state.copyWith(
        questions: questions,
        currentIndex: 0,
        isLoadingAnswers: true); // Set loading TRUE before await
    _logger.fine('Set isLoadingAnswers = true for initialization');

    final firstQuestion = questions.first;
    // Fetch answers (this will set isLoadingAnswers to false in its finally block)
    await _fetchAndSetAnswers(
        firstQuestion.answerIds, languageCode, firstQuestion.id);

    // Log overall success *after* fetching attempt
    _logger.info(
        '✅ Quiz initialization process complete for ${questions.length} questions.');
  }

  /// Returns the quiz progress as a percentage (0.0 to 1.0)
  double getProgress() {
    if (state.questions.isEmpty || state.currentIndex < 0) return 0.0;
    return (state.currentIndex + 1) / state.questions.length;
  }

  /// Determines if there are more questions left
  bool hasNextQuestion() =>
      state.currentIndex >= 0 &&
      state.currentIndex + 1 < state.questions.length;

  /// Moves to the next question (if available) and fetches its answers.
  Future<void> loadNextQuestion(String languageCode) async {
    if (hasNextQuestion()) {
      final nextIndex = state.currentIndex + 1;
      // Set new index and mark as loading answers
      state = state.copyWith(
          currentIndex: nextIndex,
          isLoadingAnswers: true); // Set loading TRUE before await
      _logger.fine(
          'Loading next question: Index $nextIndex, Set isLoadingAnswers = true');

      final currentQuestion = state.questions[nextIndex];
      // Fetch answers (this will set isLoadingAnswers to false in its finally block)
      await _fetchAndSetAnswers(
          currentQuestion.answerIds, languageCode, currentQuestion.id);
    } else {
      _logger.fine('No next question available.');
    }
  }

  /// Checks the user's selected answers against the correct answers
  /// and updates the state with lists of correct, incorrect, and missed answer IDs.
  void checkAnswers() {
    final answers = ref.read(answersNotifierProvider);

    if (answers.isEmpty) {
      _logger.warning(
          '⚠️ checkAnswers called but AnswersNotifier is empty. Cannot check.');
      // Ensure lists are empty if no answers are present
      state = state.copyWith(
        correctAnswers: [],
        incorrectAnswers: [],
        missedCorrectAnswers: [],
      );
      return;
    }
    _logger.fine('Checking answers...');

    final evaluationResult = evaluateAnswers(answers);

    // Update the state with the evaluation results using copyWith
    state = state.copyWith(
      correctAnswers: evaluationResult.correct.map((a) => a.id).toList(),
      incorrectAnswers: evaluationResult.incorrect.map((a) => a.id).toList(),
      missedCorrectAnswers: evaluationResult.missed.map((a) => a.id).toList(),
    );

    _logger.fine(
        'Check complete: Correct: ${state.correctAnswers.length}, Incorrect: ${state.incorrectAnswers.length}, Missed: ${state.missedCorrectAnswers.length}');
  }

  /// Resets the quiz state and associated notifiers.
  void resetQuiz() {
    _logger.info('Resetting quiz state.');
    state = QuizState.initial();
    try {
      ref.read(answersNotifierProvider.notifier).resetAnswers();
    } catch (e) {
      _logger.severe('Error resetting answers notifier during quiz reset: $e');
    }
  }

  /// Gets the localized text of all correct answers for the current question.
  List<String> getAllCorrectAnswersForCurrentQuestion(String languageCode) {
    final currentAnswers = ref.read(answersNotifierProvider);

    if (currentAnswers.isEmpty) {
      _logger.warning(
          '⚠️ getAllCorrectAnswersForCurrentQuestion called but AnswersNotifier is empty.');
      return [];
    }

    final allCorrectAnswers = <String>[];
    for (final answer in currentAnswers) {
      if (answer.isCorrect) {
        final text = languageCode == 'de' ? answer.textDe : answer.textEn;
        allCorrectAnswers.add(text);
      }
    }
    _logger.fine(
        'Retrieved ${allCorrectAnswers.length} correct answer texts for the current question.');
    return allCorrectAnswers;
  }
}
