import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/quiz_filtering.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('FeedbackBottomSheetView');

class FeedbackBottomSheetView extends ConsumerWidget {
  const FeedbackBottomSheetView({
    super.key,
    required this.onBtnPressed,
    required this.languageCode,
  });

  final VoidCallback onBtnPressed;
  final String languageCode;

  /// Helper function to get the localized text for an answer.
  String _getLocalizedAnswerText(Answer answer) {
    return languageCode == 'de' ? answer.textDe : answer.textEn;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch necessary providers
    final quizState = ref.watch(quizStateNotifierProvider);
    final currentAnswers = ref.watch(answersNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    // Filter answers based on the current state
    final filtered = filterAnswers(quizState, currentAnswers);

    // Determine the appropriate button label
    final String btnLbl =
        quizState.currentIndex + 1 < quizState.questions.length
            ? localizations.nextQuestionBtnLbl
            : localizations.finishQuizBtnLbl;

    _logger.fine(
        'Building FeedbackBottomSheetView. Correct: ${filtered.correct.length}, Incorrect: ${filtered.incorrect.length}, Missed: ${filtered.missed.length}');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Crucial for bottom sheet height
          children: [
            Text(
              localizations.feedBackBottomSheetTitle,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Correct Answers Section
            if (filtered.correct.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: BrainBenchColors.correctAnswerGlass),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetCorrectAnswers,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
              ...filtered.correct.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${_getLocalizedAnswerText(a)}',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: BrainBenchColors.correctAnswerGlass),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Incorrect Answers Section
            if (filtered.incorrect.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.cancel,
                      color: BrainBenchColors.falseQuestionGlass),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetWrongAnswers,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
              ...filtered.incorrect.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${_getLocalizedAnswerText(a)}',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: BrainBenchColors.falseQuestionGlass),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Missed Correct Answers Section
            if (filtered.missed.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetMissedCorrectAnswers,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
              ...filtered.missed.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${_getLocalizedAnswerText(a)}',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // TODO: Consider adding Explanation section if available
            // final explanation = quizState.questions[quizState.currentIndex].explanation;
            // if (explanation != null && explanation.isNotEmpty) ... [ ... ]

            const SizedBox(height: 48),
            Center(
              child: LightDarkSwitchBtn(
                title: btnLbl,
                isActive: true,
                onPressed: onBtnPressed,
              ),
            ),
            const SizedBox(height: 16), // Bottom padding
          ],
        ),
      ),
    );
  }
}
