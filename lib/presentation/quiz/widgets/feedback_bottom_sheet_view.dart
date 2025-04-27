import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';

/// This widget displays a bottom sheet that provides feedback to the user after answering a quiz question.
/// It shows the correct answers, incorrect answers, and any missed correct answers.
class FeedbackBottomSheetView extends StatelessWidget {
  /// Creates a [FeedbackBottomSheetView].
  ///
  /// [correctAnswers] is a list of the correct answers.
  /// [incorrectAnswers] is a list of the user's incorrect answers.
  /// [missedCorrectAnswers] is a list of correct answers the user did not select.
  /// [btnLbl] is the label for the button, which may be "Next Question" or "Finish Quiz".
  /// [onBtnPressed] is the callback function for when the button is pressed.
  /// [languageCode] is the current language code ('en' or 'de'). // <-- Hinzugefügt
  const FeedbackBottomSheetView({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
    required this.btnLbl,
    required this.onBtnPressed,
    required this.languageCode, // <-- Hinzugefügt
  });

  /// The list of correct answers.
  final List<Answer> correctAnswers;

  /// The list of incorrect answers selected by the user.
  final List<Answer> incorrectAnswers;

  /// The list of correct answers that the user did not select.
  final List<Answer> missedCorrectAnswers;

  /// The label for the action button (e.g., "Next Question", "Finish Quiz").
  final String btnLbl;

  /// Callback function executed when the action button is pressed.
  final VoidCallback onBtnPressed;

  /// The current language code ('en' or 'de'). // <-- Hinzugefügt
  final String languageCode; // <-- Hinzugefügt

  @override
  Widget build(BuildContext context) {
    // Retrieve the app's localizations for translating text.
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final TextTheme textTheme =
        Theme.of(context).textTheme; // Besser Theme.of verwenden

    // Helper function to get localized text
    String getLocalizedAnswerText(Answer answer) {
      return languageCode == 'de' ? answer.textDe : answer.textEn;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title of the bottom sheet.
            Text(
              localizations.feedBackBottomSheetTitle,
              style: textTheme.headlineMedium, // Verwende textTheme
            ),

            const SizedBox(height: 16),

            // ✅ Correct Answers Section
            if (correctAnswers.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: BrainBenchColors.correctAnswerGlass),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetCorrectAnswers,
                    style: textTheme.bodyLarge, // Verwende textTheme
                  ),
                ],
              ),
              ...correctAnswers.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${getLocalizedAnswerText(a)}', // <-- Angepasst
                    style: textTheme.bodyMedium // Verwende textTheme
                        ?.copyWith(color: BrainBenchColors.correctAnswerGlass),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ❌ Incorrect Answers Section
            if (incorrectAnswers.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.cancel,
                      color: BrainBenchColors.falseQuestionGlass),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetWrongAnswers,
                    style: textTheme.bodyLarge, // Verwende textTheme
                  ),
                ],
              ),
              ...incorrectAnswers.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${getLocalizedAnswerText(a)}', // <-- Angepasst
                    style: textTheme.bodyMedium // Verwende textTheme
                        ?.copyWith(color: BrainBenchColors.falseQuestionGlass),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ⚠️ Missed Correct Answers Section
            if (missedCorrectAnswers.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    localizations.feedbackBSheetMissedCorrectAnswers,
                    style: textTheme.bodyLarge, // Verwende textTheme
                  ),
                ],
              ),
              ...missedCorrectAnswers.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${getLocalizedAnswerText(a)}', // <-- Angepasst
                    style: textTheme.bodyMedium // Verwende textTheme
                        ?.copyWith(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 48),
            // Action Button (Next Question or Finish Quiz).
            Center(
              child: LightDarkSwitchBtn(
                title: btnLbl,
                isActive: true,
                onPressed: onBtnPressed,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
