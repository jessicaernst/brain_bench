import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:flutter/material.dart';

/// This widget displays the detailed content of a quiz answer, including the question,
/// all answer options with their correctness indicators, and an optional explanation.
class AnswerExpandableContent extends StatelessWidget {
  /// Creates an [AnswerExpandableContent].
  ///
  /// Requires a [QuizAnswer] object containing the details of the answer to display.
  const AnswerExpandableContent({super.key, required this.answer});

  /// The [QuizAnswer] object containing the details about the question and its answers.
  final QuizAnswer answer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Padding(
      // Padding around the entire content area
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 Question Section
          // Header for the question
          Text(
            localizations.answerExpandableQuestionHeader,
            style: TextTheme.of(context).bodyLarge,
          ),
          // Spacing between the header and the question text
          const SizedBox(height: 4),
          // The question text itself
          Text(answer.questionText, style: TextTheme.of(context).bodyMedium),
          // Spacing
          const SizedBox(height: 12),

          // 🟡 Answer Section
          // Displays all answer options with their indicators
          Column(
            // Creates a list of widgets based on each answer option
            children:
                answer.allAnswers.map((option) {
                  // Determine the state of the answer option
                  final bool isSelected = answer.givenAnswers.contains(option);
                  final bool isCorrect = answer.correctAnswers.contains(option);
                  final bool isMissedCorrect = !isSelected && isCorrect;
                  final bool isSelectedIncorrect = isSelected && !isCorrect;

                  // Determine icon and color based on the state
                  IconData iconData;
                  Color iconColor;
                  TextStyle? textStyle = TextTheme.of(context).bodyMedium;

                  if (isSelected && isCorrect) {
                    iconData = Icons.check_circle;
                    iconColor = BrainBenchColors.correctAnswerGlass;
                    textStyle = TextTheme.of(
                      context,
                    ).bodyLarge?.copyWith(color: iconColor);
                  } else if (isSelectedIncorrect) {
                    iconData = Icons.cancel;
                    iconColor = BrainBenchColors.falseQuestionGlass;
                    textStyle = TextTheme.of(
                      context,
                    ).bodyLarge?.copyWith(color: iconColor);
                  } else if (isMissedCorrect) {
                    iconData = Icons.info_outline;
                    iconColor = Colors.orange;
                    textStyle = TextTheme.of(
                      context,
                    ).bodyLarge?.copyWith(color: iconColor);
                  } else {
                    iconData = Icons.radio_button_unchecked;
                    iconColor = Colors.grey.shade600;
                  }

                  return Padding(
                    // Vertical padding for each answer option
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon indicating the status of the answer option
                        Icon(
                          iconData,
                          color: iconColor,
                          size: 20,
                        ), // Slightly smaller icon
                        // Spacing between icon and text
                        const SizedBox(width: 8),
                        // The answer text itself
                        Expanded(child: Text(option, style: textStyle)),
                      ],
                    ),
                  );
                }).toList(),
          ),
          // Spacing
          const SizedBox(height: 12),

          // 🔵 Explanation Section
          // Header for the explanation
          Text(
            localizations.answerExpandableExplanationHeader,
            style: TextTheme.of(context).bodyLarge,
          ),
          // Spacing
          const SizedBox(height: 4),
          AutoHyphenatingText(
            answer.explanation ?? localizations.answerExpandableNoExplanation,
            style: TextTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }
}
