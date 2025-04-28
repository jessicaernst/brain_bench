import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/quiz/widgets/feedback_bottom_sheet_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_content.dart';
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
  /// Gathers quiz answer data, saves it, and shows the result bottom sheet.
  void _prepareAndShowResultBottomSheet(String languageCode) {
    // Use ref from ConsumerState
    final quizState = ref.read(quizViewModelProvider);
    final quizAnswerNotifier = ref.read(quizAnswersNotifierProvider.notifier);
    final currentLoadedAnswers = ref.read(answersNotifierProvider);

    // --- 1. Check State Validity ---
    if (quizState.questions.isEmpty ||
        quizState.currentIndex < 0 || // Ensure index is valid
        quizState.currentIndex >= quizState.questions.length) {
      _logger.severe(
          '❌ Cannot show result bottom sheet: Invalid quiz state or index.');
      return; // Don't proceed if state is invalid
    }
    final currentQuestion = quizState.questions[quizState.currentIndex];

    // --- 2. Prepare Data ---
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

    // --- 3. Save Answer Attempt ---
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
    _logger
        .fine('Quiz answer attempt saved for question ${currentQuestion.id}');

    // --- 4. Show Bottom Sheet ---
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevent dismissing by tapping outside
      isScrollControlled: true, // Allows sheet to take more height
      builder: (ctx) {
        return Consumer(
          builder: (context, modalRef, child) {
            final latestQuizState = modalRef.watch(quizViewModelProvider);

            return FeedbackBottomSheetView(
              correctAnswers: latestQuizState.correctAnswers,
              incorrectAnswers: latestQuizState.incorrectAnswers,
              missedCorrectAnswers: latestQuizState.missedCorrectAnswers,
              // Determine button label based on whether there's a next question
              btnLbl: latestQuizState.currentIndex + 1 <
                      latestQuizState.questions.length
                  ? AppLocalizations.of(context)!.nextQuestionBtnLbl
                  : AppLocalizations.of(context)!.finishQuizBtnLbl,
              // Callback for the button press within the bottom sheet
              onBtnPressed: () {
                Navigator.pop(context);
                _handleNextQuestionOrFinish(context, languageCode);
              },
              languageCode: languageCode,
            );
          },
        );
      },
    );
  }

  Future<void> _handleNextQuestionOrFinish(
      BuildContext context, String languageCode) async {
    final quizViewModel = ref.read(quizViewModelProvider.notifier);

    if (quizViewModel.hasNextQuestion()) {
      _logger.fine('Loading next question...');
      await quizViewModel.loadNextQuestion(languageCode);
    } else {
      _logger.info('🎉 Quiz completed.');
      context.goNamed(
        AppRouteNames.quizResult,
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

    _logger.finer(
        'Build QuizPage for Topic ID: ${widget.topicId}, Language: $languageCode');

    // Use ref from ConsumerState
    final QuizViewModel quizViewModel =
        ref.read(quizViewModelProvider.notifier);
    final AsyncValue<List<Question>> questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    // Listener remains the same, triggering initialization
    ref.listen<AsyncValue<List<Question>>>(
      questionsProvider(widget.topicId, languageCode),
      (previous, next) {
        if (next is AsyncData<List<Question>>) {
          final questions = next.value;
          if (questions.isNotEmpty &&
              ref.read(quizViewModelProvider).questions.isEmpty) {
            _logger.info(
                'questionsProvider has data, triggering quiz initialization...');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check mounted status before calling async methods in callbacks
              if (mounted &&
                  ref.read(quizViewModelProvider).questions.isEmpty) {
                quizViewModel.initializeQuizIfNeeded(questions, languageCode);
              }
            });
          } else if (questions.isEmpty) {
            _logger.warning(
                'questionsProvider returned empty list, not initializing quiz.');
          }
        } else if (next is AsyncError) {
          _logger.severe('Error in questionsProvider listener: ${next.error}');
        }
      },
    );

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizAppBarTitle,
        onBack: () {
          _logger.fine(
              'Back button pressed, resetting quiz and navigating to topics.');
          quizViewModel.resetQuiz();
          context.goNamed(
            AppRouteNames.topics,
            pathParameters: {'categoryId': widget.categoryId},
          );
        },
      ),
      body: questionsAsync.when(
        // --- Delegate to _QuizContent when data is available ---
        data: (questions) => QuizContent(
          questions: questions,
          localizations: localizations,
          languageCode: languageCode,
          // Pass the refactored method to show the bottom sheet
          showResultBottomSheet: () =>
              _prepareAndShowResultBottomSheet(languageCode),
        ),
        // --- Loading state for questions ---
        loading: () {
          _logger.fine('🔄 Questions are loading...');
          return const Center(child: CircularProgressIndicator());
        },
        // --- Error state for questions ---
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
