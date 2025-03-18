import 'package:brain_bench/core/mixins/ensure_visible_mixin.dart';
import 'package:brain_bench/presentation/results/widgets/answer_expandable.dart';
import 'package:brain_bench/presentation/results/widgets/answer_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

class AnswerCard extends ConsumerStatefulWidget {
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isCorrect,
  });

  final QuizAnswer answer;
  final bool isCorrect;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnswerCardState();
}

class _AnswerCardState extends ConsumerState<AnswerCard>
    with EnsureVisibleMixin {
  @override
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final quizResultState = ref.watch(quizResultNotifierProvider);
    final stateNotifier = ref.read(quizResultNotifierProvider.notifier);
    final bool isExpanded =
        quizResultState.expandedAnswers.contains(widget.answer.questionId);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      key: cardKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnswerMainCard(
          answerText: widget.answer.questionText,
          isCorrect: widget.isCorrect,
          isExpanded: isExpanded,
          onTap: () {
            stateNotifier.toggleExplanation(widget.answer.questionId);
            if (!isExpanded) {
              ensureCardIsVisible(cardName: widget.answer.questionId);
            }
          },
          isDarkMode: isDarkMode,
        ),
        AnswerExpandable(
          isExpanded: isExpanded,
          answer: widget.answer,
        ),
      ],
    );
  }
}
