import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
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
  /// Handles moving to the next question or finishing the quiz.
  /// Includes error handling for loading and navigation.
  Future<void> _handleNextQuestionOrFinish(
      BuildContext context, String languageCode) async {
    // Get the view model instance *once*
    final quizViewModel = ref.read(quizViewModelProvider.notifier);

    // Check mounted before accessing context initially
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final navigator = GoRouter.of(context);

    if (quizViewModel.hasNextQuestion()) {
      _logger.fine('Attempting to load next question...');
      try {
        // Attempt to load the next question's data
        await quizViewModel.loadNextQuestion(languageCode);
        // If successful, the UI will rebuild based on the new state.
        _logger.fine('Successfully loaded next question data.');
        // No context use needed here after await if successful
      } catch (e, s) {
        _logger.severe('Failed to load next question: $e', e, s);
        // Check mounted AFTER await
        if (!mounted) return;
        // Use the CAPTURED objects
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.quizErrorLoadingNextQuestion),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } else {
      _logger.info('🎉 Quiz completed. Attempting to navigate to results...');
      // Check mounted AFTER potential await (though none here, good practice)
      if (!mounted) return;
      try {
        // Use the CAPTURED navigator instance
        navigator.goNamed(
          AppRouteNames.quizResult,
          pathParameters: <String, String>{
            'categoryId': widget.categoryId,
            'topicId': widget.topicId,
          },
        );
      } catch (e, s) {
        // Catch potential navigation errors
        _logger.severe('Navigation to quiz results failed: $e', e, s);
        // Check mounted AFTER potential await (though none here)
        if (!mounted) return;
        // Use the CAPTURED objects
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.errorNavigationFailed),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  /// Gathers quiz answer data, saves it, and shows the result bottom sheet.
  void _prepareAndShowResultBottomSheet(String languageCode) {
    // --- Capture context safely at the beginning ONLY for synchronous use ---
    // This is okay because it's used before any await or async callback boundary
    final BuildContext currentContext = context;
    if (!mounted) return;
    final localizations = AppLocalizations.of(currentContext)!;
    final scaffoldMessenger =
        ScaffoldMessenger.of(currentContext); // Capture for sync use
    final theme = Theme.of(currentContext); // Capture for sync use
    // ---

    // Read providers needed for saving data *before* showing the sheet
    final quizState = ref.read(quizViewModelProvider);
    final quizAnswerNotifier = ref.read(quizAnswersNotifierProvider.notifier);
    final currentLoadedAnswers = ref.read(answersNotifierProvider);

    // --- 1. Check State Validity ---
    if (quizState.questions.isEmpty ||
        quizState.currentIndex < 0 ||
        quizState.currentIndex >= quizState.questions.length) {
      _logger.severe(
          '❌ Cannot show result bottom sheet: Invalid quiz state or index.');
      if (mounted) {
        // Use the captured objects (synchronous context is fine here)
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.errorGeneric),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
      return; // Don't proceed if state is invalid
    }
    final currentQuestion = quizState.questions[quizState.currentIndex];

    // --- 2. Prepare Data for Saving ---
    // (Code remains the same)
    final selectedAnswers = currentLoadedAnswers
        .where((answer) => answer.isSelected)
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();
    final allAnswers = currentLoadedAnswers
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();
    final correctAnswers = currentLoadedAnswers
        .where((answer) => answer.isCorrect)
        .map((answer) => languageCode == 'de' ? answer.textDe : answer.textEn)
        .toList();
    final explanation = currentQuestion.explanation;
    final allCorrectAnswersText = ref
        .read(quizViewModelProvider.notifier)
        .getAllCorrectAnswersForCurrentQuestion(languageCode);
    final localizedQuestionText = currentQuestion.question;

    // --- 3. Save Answer Attempt ---
    try {
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
    } catch (e, s) {
      _logger.severe('Failed to save quiz answer attempt: $e', e, s);
      if (mounted) {
        // Use the captured objects (synchronous context is fine here)
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.errorSavingData),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
      // Depending on severity, you might want to return here
      // return;
    }

    // --- 4. Show Bottom Sheet ---
    // Check mounted *before* showing the modal
    if (!mounted) return;
    // Use the captured context (currentContext) as it's synchronous here
    showModalBottomSheet(
      context: currentContext,
      isDismissible: false,
      isScrollControlled: true,
      builder: (modalContext) {
        // Use the modal's context provided by builder
        return FeedbackBottomSheetView(
          languageCode: languageCode,
          onBtnPressed: () {
            Navigator.pop(modalContext);
            if (!mounted) return;
            _handleNextQuestionOrFinish(context, languageCode);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    _logger.finer(
        'Build QuizPage for Topic ID: ${widget.topicId}, Language: $languageCode');

    final QuizViewModel quizViewModel =
        ref.read(quizViewModelProvider.notifier);
    final AsyncValue<List<Question>> questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    // Listener to initialize the quiz when questions are loaded
    ref.listen<AsyncValue<List<Question>>>(
      questionsProvider(widget.topicId, languageCode),
      (previous, next) {
        if (!mounted) return; // Exit if widget is disposed
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final currentLocalizations = AppLocalizations.of(context);
        final theme = Theme.of(context);

        if (currentLocalizations == null) {
          _logger.warning('Localizations not available in listener callback.');
          return;
        }

        if (next is AsyncData<List<Question>>) {
          final questions = next.value;
          // Check if quiz is NOT already initialized before attempting init
          if (questions.isNotEmpty &&
              ref.read(quizViewModelProvider).questions.isEmpty) {
            _logger.info(
                'questionsProvider has data, triggering quiz initialization...');
            // Use addPostFrameCallback to avoid state changes during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check mounted inside post frame callback as well
              if (mounted &&
                  ref.read(quizViewModelProvider).questions.isEmpty) {
                // Consider try-catch if initializeQuizIfNeeded can throw and needs UI feedback here
                quizViewModel.initializeQuizIfNeeded(questions, languageCode);
              }
            });
          } else if (questions.isEmpty) {
            _logger.warning(
                'questionsProvider returned empty list, not initializing quiz.');
            if (mounted) {
              // Re-check mounted just before showing SnackBar
              // Use objects obtained after mounted check
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(currentLocalizations.quizErrorNoQuestions),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          }
        } else if (next is AsyncError) {
          _logger.severe('Error in questionsProvider listener: ${next.error}');
          if (mounted) {
            // Re-check mounted just before showing SnackBar
            // Use objects obtained after mounted check
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(currentLocalizations.quizErrorLoadingQuestions),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        }
      },
    );

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizAppBarTitle,
        onBack: () {
          _logger.fine(
              'Back button pressed, resetting quiz and navigating to topics.');
          // Resetting is synchronous
          quizViewModel.resetQuiz();
          // --- CORRECT LINT FIX: Check mounted, then use context directly inside callback ---
          // This callback is synchronous.
          if (!mounted) return;
          // Use 'context' property directly after mounted check
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final currentLocalizations = AppLocalizations.of(context)!;
          final theme = Theme.of(context);
          final navigator = GoRouter.of(context);

          try {
            navigator.goNamed(
              // Use captured navigator
              AppRouteNames.topics,
              pathParameters: {'categoryId': widget.categoryId},
            );
          } catch (e, s) {
            _logger.severe('Navigation back to topics failed: $e', e, s);
            if (!mounted) return; // Re-check mounted before showing SnackBar
            // Use objects obtained after mounted check
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(currentLocalizations.errorNavigationFailed),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
          // --- END CORRECT LINT FIX ---
        },
      ),
      body: questionsAsync.when(
        // Delegate to QuizContent when data is available
        data: (questions) {
          // Handle case where provider returns data but the list is empty
          if (questions.isEmpty) {
            _logger.warning(
                'Questions provider returned data, but the list is empty.');
            // Display the error message directly in the body as before
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localizations.quizErrorNoQuestions,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // Proceed with QuizContent if questions are available
          return QuizContent(
            questions: questions,
            localizations: localizations,
            languageCode: languageCode,
            showResultBottomSheet: () =>
                _prepareAndShowResultBottomSheet(languageCode),
          );
        },
        // Loading state for questions
        loading: () {
          _logger.fine('🔄 Questions are loading...');
          return const Center(child: CircularProgressIndicator());
        },
        // Error state for questions
        error: (error, stack) {
          _logger.severe('❌ Error loading questions: $error', error, stack);
          // Display the error message directly in the body as before
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                localizations.quizErrorLoadingQuestions,
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
