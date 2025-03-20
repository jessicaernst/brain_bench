import 'package:brain_bench/core/component_widgets/card_expandable_content.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/presentation/results/widgets/answer_expandable_content.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the expandable content for an answer in a quiz.
class AnswerExpandable extends HookConsumerWidget {
  const AnswerExpandable({
    super.key,
    required this.isExpanded,
    required this.answer,
  });

  final bool isExpanded;
  final QuizAnswer answer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardExpandableContent(
      isExpanded: isExpanded,
      padding: 32,
      lightGradient: BrainBenchGradients.answerContentCardLightGradient,
      darkGradient: BrainBenchGradients.answerContentCardDarkGradient,
      child: AnswerExpandableContent(answer: answer),
    );
  }
}
