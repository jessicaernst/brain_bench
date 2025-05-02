import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/quiz/widgets/feedback_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_page_controller.g.dart';

final Logger _logger = Logger('QuizPageController');

/// Handles UI logic and interactions for the QuizPage.
@Riverpod(keepAlive: true)
class QuizPageController extends _$QuizPageController {
  @visibleForTesting
  GoRouter Function(BuildContext)? navigatorOverride;

  @override
  void build({required String topicId, required String categoryId}) {
    return;
  }

  QuizStateNotifier get quizStateNotifier =>
      ref.read(quizStateNotifierProvider.notifier);

  /// Handles moving to the next question or finishing the quiz.
  Future<void> handleNextQuestionOrFinish(BuildContext context,
      bool Function() isMounted, String languageCode) async {
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    if (quizStateNotifier.hasNextQuestion()) {
      _logger.fine('Attempting to load next question...');
      try {
        await quizStateNotifier.loadNextQuestion(languageCode);
        _logger.fine('Successfully loaded next question data.');
      } catch (e, s) {
        _logger.severe('Failed to load next question: $e', e, s);
        if (!isMounted()) return;
        showErrorSnackBar(scaffoldMessenger, theme, isMounted,
            localizations.quizErrorLoadingNextQuestion);
      }
    } else {
      _logger.info('🎉 Quiz completed. Attempting to navigate to results...');
      if (!isMounted()) return;
      try {
        navigator(context).goNamed(
          AppRouteNames.quizResult,
          pathParameters: <String, String>{
            'categoryId': categoryId,
            'topicId': topicId,
          },
        );
      } catch (e, s) {
        _logger.severe('Navigation to quiz results failed: $e', e, s);
        if (!isMounted()) return;
        showErrorSnackBar(scaffoldMessenger, theme, isMounted,
            localizations.errorNavigationFailed);
      }
    }
  }

  // Helper for navigation as GoRouter needs context
  @visibleForTesting
  GoRouter navigator(BuildContext context) =>
      navigatorOverride?.call(context) ?? GoRouter.of(context);

  /// Gathers quiz answer data, saves it, and shows the result bottom sheet.
  void prepareAndShowResultBottomSheet(
      BuildContext context, bool Function() isMounted, String languageCode) {
    final quizState = ref.read(quizStateNotifierProvider);
    final quizAnswerNotifier = ref.read(quizAnswersNotifierProvider.notifier);
    final currentLoadedAnswers = ref.read(answersNotifierProvider);

    if (quizState.questions.isEmpty ||
        quizState.currentIndex < 0 ||
        quizState.currentIndex >= quizState.questions.length) {
      _logger.severe(
          '❌ Cannot show result bottom sheet: Invalid quiz state or index.');
      if (!isMounted()) return;
      showErrorSnackBar(ScaffoldMessenger.of(context), Theme.of(context),
          isMounted, AppLocalizations.of(context)!.errorGeneric);
      return;
    }
    final currentQuestion = quizState.questions[quizState.currentIndex];

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
        .read(quizStateNotifierProvider.notifier)
        .getAllCorrectAnswersForCurrentQuestion(languageCode);
    final localizedQuestionText = currentQuestion.question;

    try {
      quizAnswerNotifier.addAnswer(
        questionId: currentQuestion.id,
        topicId: currentQuestion.topicId,
        categoryId: categoryId,
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
      if (!isMounted()) return;
      showErrorSnackBar(ScaffoldMessenger.of(context), Theme.of(context),
          isMounted, AppLocalizations.of(context)!.errorSavingData);
    }

    _showFeedbackBottomSheet(context, isMounted, languageCode);
  }

  /// Handles the back button press: resets quiz and navigates.
  void handleBackButton(BuildContext context, bool Function() isMounted) {
    _logger
        .fine('Back button pressed, resetting quiz and navigating to topics.');
    quizStateNotifier.resetQuiz();
    if (!isMounted()) return;
    try {
      navigator(context).goNamed(
        AppRouteNames.topics,
        pathParameters: {'categoryId': categoryId},
      );
    } catch (e, s) {
      _logger.severe('Navigation back to topics failed: $e', e, s);
      if (!isMounted()) return;
      showErrorSnackBar(ScaffoldMessenger.of(context), Theme.of(context),
          isMounted, AppLocalizations.of(context)!.errorNavigationFailed);
    }
  }

  void _showFeedbackBottomSheet(
      BuildContext context, bool Function() isMounted, String languageCode) {
    if (!isMounted()) return;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (modalContext) {
        return FeedbackBottomSheetView(
          languageCode: languageCode,
          onBtnPressed: () {
            Navigator.pop(modalContext);
            if (!isMounted()) return;
            handleNextQuestionOrFinish(context, isMounted, languageCode);
          },
        );
      },
    );
  }

  void showErrorSnackBar(ScaffoldMessengerState scaffoldMessenger,
      ThemeData theme, bool Function() isMounted, String message) {
    if (!isMounted()) return;
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}
