import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/quiz/widgets/feedback_bottom_sheet_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/single_multtiple_question_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizPage');

class QuizPage extends ConsumerStatefulWidget {
  QuizPage({
    super.key,
    required this.topicId,
    required this.categoryId,
  });

  final String topicId;
  final String categoryId;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  /// Displays the result bottom sheet after a question is answered.
  // Removed WidgetRef ref parameter as it's available via ConsumerState
  void _showResultBottomSheet(BuildContext context, String languageCode) {
    // Use ref from ConsumerState
    final quizState = ref.read(quizViewModelProvider);
    final quizAnswerNotifier = ref.read(quizAnswersNotifierProvider.notifier);
    final currentLoadedAnswers = ref.read(answersNotifierProvider);

    if (quizState.questions.isEmpty ||
        quizState.currentIndex >= quizState.questions.length) {
      _logger.severe(
          '❌ Cannot show result bottom sheet: Invalid quiz state or index.');
      return;
    }
    final currentQuestion = quizState.questions[quizState.currentIndex];

    // User-selected answers
    final selectedAnswers = currentLoadedAnswers
        .where((answer) => answer.isSelected)
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();

    // Collect all possible answers for UI representation
    final allAnswers = currentLoadedAnswers
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();

    // Get the correct answers
    final correctAnswers = currentLoadedAnswers
        .where((answer) => answer.isCorrect)
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();

    // Get explanation if available
    final explanation = currentQuestion.explanation;

    // Get all correct answers text
    final allCorrectAnswersText = ref
        .read(quizViewModelProvider.notifier)
        .getAllCorrectAnswersForCurrentQuestion(languageCode);

    final localizedQuestionText = currentQuestion.question;

    // Save answer with all information
    quizAnswerNotifier.addAnswer(
      questionId: currentQuestion.id,
      topicId: currentQuestion.topicId,
      categoryId: widget.categoryId,
      questionText: localizedQuestionText,
      givenAnswers: selectedAnswers,
      correctAnswers: correctAnswers,
      allAnswers: allAnswers,
      explanation: explanation,
      allCorrectAnswers: allCorrectAnswersText,
    );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (ctx) {
        // Use the 'ref' provided by the Consumer builder here
        return Consumer(
          builder: (context, modalRef, child) {
            // Use modalRef here
            final latestQuizState = modalRef.watch(quizViewModelProvider);

            return FeedbackBottomSheetView(
              correctAnswers: latestQuizState.correctAnswers,
              incorrectAnswers: latestQuizState.incorrectAnswers,
              missedCorrectAnswers: latestQuizState.missedCorrectAnswers,
              btnLbl: latestQuizState.currentIndex + 1 <
                      latestQuizState.questions.length
                  ? AppLocalizations.of(context)!.nextQuestionBtnLbl
                  : AppLocalizations.of(context)!.finishQuizBtnLbl,
              onBtnPressed: () {
                Navigator.pop(context);
                // --- Removed ref from call ---
                _handleNextQuestionOrFinish(context, languageCode);
              },
              languageCode: languageCode,
            );
          },
        );
      },
    );
  }

  /// Handles logic to either load the next question or finish the quiz.
  // Removed WidgetRef ref parameter
  Future<void> _handleNextQuestionOrFinish(
      BuildContext context, String languageCode) async {
    // Use ref from ConsumerState
    final quizViewModel = ref.read(quizViewModelProvider.notifier);

    if (quizViewModel.hasNextQuestion()) {
      // --- Removed ref from call ---
      await quizViewModel.loadNextQuestion(languageCode);
    } else {
      _logger.info('🎉 Quiz completed.');
      // Use ref from ConsumerState for navigation context if needed, but GoRouter uses BuildContext
      context.goNamed(
        '/categories/details/topics/quiz/result',
        pathParameters: <String, String>{
          'categoryId': widget.categoryId,
          'topicId': widget.topicId,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    _logger.info(
        '📌 Build QuizPage for Topic ID: ${widget.topicId}, Language: $languageCode');

    // Use ref from ConsumerState
    final QuizViewModel quizViewModel =
        ref.read(quizViewModelProvider.notifier);
    final AsyncValue<List<Question>> questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizAppBarTitle,
        onBack: () {
          // --- Removed ref from call ---
          quizViewModel.resetQuiz();
          // Use context for navigation
          context.goNamed(
            AppRouteNames.topics,
            pathParameters: {'categoryId': widget.categoryId},
          );
        },
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            _logger.warning(
                '⚠️ No questions found for Topic ID: ${widget.topicId}');
            return NoDataAvailableView(
                text: localizations.quizNoQuestionsAvailable);
          }

          // Initialize the quiz (loads first question's answers)
          Future.microtask(() async {
            // Use ref from ConsumerState
            if (ref.read(quizViewModelProvider).questions.isEmpty) {
              _logger.info('Triggering quiz initialization...');
              // --- Removed ref from call ---
              await quizViewModel.initializeQuizIfNeeded(
                  questions, languageCode);
            }
          });

          // Watch the state AFTER potential initialization
          // Use ref from ConsumerState
          final quizState = ref.watch(quizViewModelProvider);

          // Check if initialization is still pending or failed
          if (quizState.questions.isEmpty) {
            _logger.warning(
                '⚠️ Quiz state questions are still empty. Waiting for initialization or error.');
            return const Center(child: CircularProgressIndicator());
          }

          // Get the currently loaded answers from the notifier
          // Use ref from ConsumerState
          final List<Answer> currentAnswers =
              ref.watch(answersNotifierProvider);

          // Check if answers for the current question are loaded
          if (currentAnswers.isEmpty && quizState.questions.isNotEmpty) {
            _logger.warning(
                '⚠️ AnswersNotifier is empty, likely loading answers for index ${quizState.currentIndex}...');
            return const Center(child: CircularProgressIndicator());
          }

          // Get the current question (has only answerIds)
          final Question currentQuestion =
              quizState.questions[quizState.currentIndex];
          final bool isMultipleChoice =
              currentQuestion.type == QuestionType.multipleChoice;
          final double progress = quizViewModel.getProgress();

          _logger.info(
              '✅ Displaying question index: ${quizState.currentIndex}, ID: ${currentQuestion.id}, Type: ${currentQuestion.type}, Progress: ${(progress * 100).toStringAsFixed(1)}%');
          _logger
              .fine('Current loaded answers count: ${currentAnswers.length}');

          // Get the notifier instance for the AnswerListView callback
          // Use ref from ConsumerState
          final AnswersNotifier answersNotifier =
              ref.read(answersNotifierProvider.notifier);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleMulttipleQuestionView(
              progress: progress,
              currentQuestion: currentQuestion,
              isMultipleChoice: isMultipleChoice,
              answersNotifier: answersNotifier,
              localizations: localizations,
              answers: currentAnswers,
              onAnswerSelected: () {
                // Use ref from ConsumerState
                final answersForCheck = ref.read(answersNotifierProvider);
                if (answersForCheck.any((answer) => answer.isSelected)) {
                  _logger.info('🟢 Submit button pressed');
                  // --- Removed ref from call ---
                  quizViewModel.checkAnswers();
                  // --- Removed ref from call ---
                  _showResultBottomSheet(context, languageCode);
                } else {
                  _logger.warning('⚠️ No answers selected.');
                }
              },
            ),
          );
        },
        loading: () {
          _logger.info('🔄 Questions are loading...');
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          _logger.severe('❌ Error loading questions: $error', error, stack);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${localizations.quizErrorLoadingQuestions}\n$error',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
