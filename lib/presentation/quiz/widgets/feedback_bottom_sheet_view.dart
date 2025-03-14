import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/data/models/answer.dart';

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
  const FeedbackBottomSheetView({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
    required this.btnLbl,
    required this.onBtnPressed,
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

  @override
  Widget build(BuildContext context) {
    // Retrieve the app's localizations for translating text.
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
              style: TextTheme.of(context).headlineMedium,
            ),

            const SizedBox(height: 16),

            // ✅ Correct Answers Section
            // Conditionally display the section only if there are correct answers.
            if (correctAnswers.isNotEmpty) ...[
              Row(
                children: [
                  // Icon to indicate correct answers.
                  const Icon(Icons.check_circle,
                      color: BrainBenchColors.correctAnswerGlass),

                  const SizedBox(width: 8),
                  // Text label for the correct answers section.
                  Text(
                    localizations.feedbackBSheetCorrectAnswers,
                    style: TextTheme.of(context).bodyLarge,
                  ),
                ],
              ),
              // Display each correct answer with a bullet point.
              ...correctAnswers.map(
                (a) => Padding(
                  // Add left padding for alignment.
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${a.text}',
                    style: TextTheme.of(context)
                        .bodyMedium
                        ?.copyWith(color: BrainBenchColors.correctAnswerGlass),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],

            // ❌ Incorrect Answers Section
            // Conditionally display the section only if there are incorrect answers.
            if (incorrectAnswers.isNotEmpty) ...[
              Row(
                children: [
                  // Icon to indicate incorrect answers.
                  const Icon(Icons.cancel,
                      color: BrainBenchColors.falseQuestionGlass),

                  const SizedBox(width: 8),
                  // Text label for the incorrect answers section.
                  Text(
                    localizations.feedbackBSheetWrongAnswers,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              // Display each incorrect answer with a bullet point.
              ...incorrectAnswers.map(
                (a) => Padding(
                  // Add left padding for alignment.
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${a.text}',
                    style: TextTheme.of(context)
                        .bodyMedium
                        ?.copyWith(color: BrainBenchColors.falseQuestionGlass),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],

            // ⚠️ Missed Correct Answers Section
            // Conditionally display the section only if there are missed correct answers.
            if (missedCorrectAnswers.isNotEmpty) ...[
              Row(
                children: [
                  // Icon to indicate missed correct answers.
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  // Spacing between the icon and text.
                  const SizedBox(width: 8),
                  // Text label for the missed correct answers section.
                  Text(
                    localizations.feedbackBSheetMissedCorrectAnswers,
                    style: TextTheme.of(context).bodyLarge,
                  ),
                ],
              ),
              // Display each missed correct answer with a bullet point.
              ...missedCorrectAnswers.map(
                (a) => Padding(
                  // Add left padding for alignment.
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '- ${a.text}',
                    style: TextTheme.of(context)
                        .bodyMedium
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
