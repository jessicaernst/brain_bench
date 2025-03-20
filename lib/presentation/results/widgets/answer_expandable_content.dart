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
  const AnswerExpandableContent({
    super.key,
    required this.answer,
  });

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
          Text(
            answer.questionText,
            style: TextTheme.of(context).bodyMedium,
          ),
          // Spacing
          const SizedBox(height: 12),

          // 🟡 Answer Section
          // Displays all answer options with their indicators
          Column(
            // Creates a list of widgets based on each answer option
            children: answer.allAnswers.map((option) {
              // Check if the current option was selected by the user
              final bool isSelected = answer.givenAnswers.contains(option);
              // Check if the current option is a correct answer
              final bool isCorrect = answer.correctAnswers.contains(option);
              // Check if the current option is a correct answer that the user missed
              final bool isMissedCorrect = !isSelected && isCorrect;

              return Padding(
                // Vertical padding for each answer option
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // Icon indicating the status of the answer option
                    Icon(
                      isSelected
                          ? (isCorrect
                              ? Icons.check_circle
                              : Icons
                                  .cancel) // If selected, show check or cancel
                          : (isMissedCorrect
                              ? Icons.info // If missed correct, show info icon
                              : Icons
                                  .radio_button_unchecked), // Otherwise, show unchecked radio button
                      color: isSelected
                          ? (isCorrect
                              ? BrainBenchColors.correctAnswerGlass
                              : BrainBenchColors.falseQuestionGlass)
                          : (isMissedCorrect ? Colors.orange : Colors.grey),
                    ),
                    // Spacing between icon and text
                    const SizedBox(width: 8),
                    // The answer text itself
                    Expanded(
                      child: Text(
                        option,
                        style: isSelected || isMissedCorrect
                            ? TextTheme.of(context).bodyLarge?.copyWith(
                                  color: isSelected
                                      ? (isCorrect
                                          ? BrainBenchColors.correctAnswerGlass
                                          : BrainBenchColors.falseQuestionGlass)
                                      : (isMissedCorrect
                                          ? Colors.orange
                                          : Colors.grey.shade600),
                                )
                            : TextTheme.of(context).bodyMedium?.copyWith(
                                  color: isSelected
                                      ? (isCorrect
                                          ? BrainBenchColors.correctAnswerGlass
                                          : BrainBenchColors.falseQuestionGlass)
                                      : (isMissedCorrect
                                          ? Colors.orange
                                          : Colors.grey.shade600),
                                ),
                      ),
                    ),
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
          // Explanation text, if available, or a default message
          Text(
            answer.explanation ?? localizations.answerExpandableNoExplanation,
            style: TextTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }
}
