import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_question_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizContent');

class QuizContent extends ConsumerWidget {
  const QuizContent({
    super.key,
    required this.questions,
    required this.localizations,
    required this.languageCode,
    required this.showResultBottomSheet,
  });

  final List<Question> questions;
  final AppLocalizations localizations;
  final String languageCode;
  final VoidCallback showResultBottomSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the dependent states needed for rendering
    final quizState = ref.watch(quizStateNotifierProvider);
    final List<Answer> currentAnswers = ref.watch(answersNotifierProvider);
    // Read view model and notifier for actions
    final quizViewModel = ref.read(quizStateNotifierProvider.notifier);
    final answersNotifier = ref.read(answersNotifierProvider.notifier);

    // --- Loading Condition 1: QuizViewModel hasn't been initialized yet ---
    if (quizState.questions.isEmpty) {
      if (questions.isEmpty) {
        // This case is handled by the parent's listener, but good to have a fallback UI
        _logger
            .warning('⚠️ No questions found for Topic ID: (in _QuizContent)');
        return NoDataAvailableView(
            text: localizations.quizNoQuestionsAvailable);
      }
      _logger.fine(
          'Waiting for QuizViewModel initialization... (in _QuizContent)');
      return const Center(child: CircularProgressIndicator());
    }

    // --- Loading Condition 2: ViewModel is loading answers ---
    if (quizState.isLoadingAnswers) {
      _logger.fine(
          '⏳ QuizViewModel is loading answers for index ${quizState.currentIndex}... (in _QuizContent)');
      return const Center(child: CircularProgressIndicator());
    }

    // --- Fallback Check: Answers still empty after loading finished ---
    if (currentAnswers.isEmpty) {
      _logger.warning(
          '⚠️ isLoadingAnswers is false, but currentAnswers is empty. Potential issue loading answers for index ${quizState.currentIndex}. (in _QuizContent)');
      // Show loading or error? Let's keep loading for now.
      return const Center(child: CircularProgressIndicator());
    }

    // --- Index Check ---
    if (quizState.currentIndex < 0 ||
        quizState.currentIndex >= quizState.questions.length) {
      _logger.severe(
          '❌ Invalid currentIndex (${quizState.currentIndex}) in _QuizContent build.');
      return Center(child: Text('Internal error: Invalid question index.'));
    }

    // --- Data is ready, render the actual question display ---
    final Question currentQuestion =
        quizState.questions[quizState.currentIndex];
    final bool isMultipleChoice =
        currentQuestion.type == QuestionType.multipleChoice;
    final double progress = quizViewModel.getProgress();

    _logger.finer(
        'Displaying question index: ${quizState.currentIndex}, ID: ${currentQuestion.id} (in _QuizContent)');

    // Delegate to the previously extracted _QuizQuestionDisplay
    return QuizQuestionDisplay(
      progress: progress,
      currentQuestion: currentQuestion,
      isMultipleChoice: isMultipleChoice,
      answersNotifier: answersNotifier,
      localizations: localizations,
      currentAnswers: currentAnswers,
      onSubmit: () {
        // Encapsulate submit logic here
        final answersForCheck =
            ref.read(answersNotifierProvider); // Read fresh state
        if (answersForCheck.any((answer) => answer.isSelected)) {
          _logger.info('🟢 Submit button pressed (via _QuizContent)');
          quizViewModel.checkAnswers();
          showResultBottomSheet(); // Call the passed callback
        } else {
          _logger.warning('⚠️ No answers selected. (via _QuizContent)');
        }
      },
    );
  }
}
