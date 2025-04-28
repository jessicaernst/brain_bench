import 'package:brain_bench/presentation/results/widgets/answer_expandable.dart';
import 'package:brain_bench/presentation/results/widgets/answer_main_card.dart';
import 'package:flutter/material.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';

/// This widget represents a single answer card in the quiz result page.
///
/// It displays the main answer information and provides an expandable area
/// for more detailed content, such as the explanation. It receives its
/// expanded state and toggle callback from the parent widget.
// Changed to StatelessWidget as state is managed externally
class AnswerCard extends StatelessWidget {
  /// Creates an [AnswerCard].
  ///
  /// [key]: Required for efficient list updates. Passed from the parent.
  /// [answer]: The [QuizAnswer] object containing the data to display.
  /// [isCorrect]: A boolean indicating whether the answer evaluation was correct.
  /// [isExpanded]: A boolean indicating if the card should display its expanded content.
  /// [onToggle]: Callback function invoked when the card is tapped to toggle expansion.
  const AnswerCard({
    super.key, // Accept the key passed from the parent (e.g., ValueKey)
    required this.answer,
    required this.isCorrect,
    required this.isExpanded, // Added required parameter
    required this.onToggle, // Added required parameter
  });

  /// The [QuizAnswer] object containing the data to display.
  final QuizAnswer answer;

  /// A boolean indicating whether the answer evaluation was correct.
  final bool isCorrect;

  /// A boolean indicating if the card should display its expanded content.
  final bool isExpanded; // Added field

  /// Callback function invoked when the card is tapped to toggle expansion.
  final VoidCallback onToggle; // Added field

  // Removed State class and EnsureVisibleMixin

  @override
  Widget build(BuildContext context) {
    // No longer needs ref.watch here for expansion state

    // Check if the app is in dark mode.
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // The key provided in the constructor is automatically applied to this widget.
    return Column(
      // Removed key: cardKey, as the key is on the AnswerCard itself now
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main card area that displays the question and handles expansion trigger.
        AnswerMainCard(
          answerText: answer.questionText,
          isCorrect: isCorrect,
          isExpanded: isExpanded, // Use passed parameter
          onTap:
              onToggle, // Use passed callback directly to trigger state change in notifier
          isDarkMode: isDarkMode,
        ),
        // The expandable area that contains detailed information about the answer.
        // Its visibility is controlled by the passed isExpanded flag.
        AnswerExpandable(
          isExpanded: isExpanded, // Use passed parameter
          answer: answer,
        ),
      ],
    );
  }
}
