import 'package:brain_bench/core/mixins/ensure_visible_mixin.dart';
import 'package:brain_bench/presentation/results/widgets/answer_expandable.dart';
import 'package:brain_bench/presentation/results/widgets/answer_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

/// This widget represents a single answer card in the quiz result page.
///
/// It displays the main answer information and provides an expandable area
/// for more detailed content, such as the explanation.
class AnswerCard extends ConsumerStatefulWidget {
  /// Creates an [AnswerCard].
  ///
  /// [answer]: The [QuizAnswer] object containing the data to display.
  /// [isCorrect]: A boolean indicating whether the answer is correct.
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isCorrect,
  });

  /// The [QuizAnswer] object containing the data to display.
  final QuizAnswer answer;

  /// A boolean indicating whether the answer is correct.
  final bool isCorrect;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnswerCardState();
}

/// The state for the [AnswerCard] widget.
///
/// This state handles the interaction with the card, such as expanding/collapsing
/// and ensuring the card is visible when expanded.
class _AnswerCardState extends ConsumerState<AnswerCard>
    with EnsureVisibleMixin {
  // We use the mixin to ensure the card is visible when expanded.

  // ✅ Add a GlobalKey to each AnswerCard - Allows us to identify this card uniquely in the widget tree.
  @override
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Access the current quiz result state from the provider.
    final quizResultState = ref.watch(quizResultNotifierProvider);

    // Access the notifier to trigger state changes.
    final stateNotifier = ref.read(quizResultNotifierProvider.notifier);

    // Check if the current answer card is expanded.
    final bool isExpanded =
        quizResultState.expandedAnswers.contains(widget.answer.questionId);

    // Check if the app is in dark mode.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ Use the key in the Column - Assign the GlobalKey to the main widget to identify it.
    return Column(
      key: cardKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main card area that displays the question and handles expansion.
        AnswerMainCard(
          answerText: widget.answer.questionText,
          isCorrect: widget.isCorrect,
          isExpanded: isExpanded,
          onTap: () {
            // Toggle the explanation for the current answer.
            stateNotifier.toggleExplanation(widget.answer.questionId);
            // ✅ Ensure the card is visible after tapping - If the card is not expanded, ensure it is visible.
            if (!isExpanded) {
              ensureCardIsVisible(
                  cardName: widget.answer.questionId); // Make the card visible.
            }
          },
          isDarkMode: isDarkMode,
        ),
        // The expandable area that contains detailed information about the answer.
        AnswerExpandable(
          isExpanded: isExpanded,
          answer: widget.answer,
        ),
      ],
    );
  }
}
