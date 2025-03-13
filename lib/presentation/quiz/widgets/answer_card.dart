import 'package:brain_bench/presentation/quiz/widgets/answer_expandable.dart';
import 'package:brain_bench/presentation/quiz/widgets/answer_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/quiz/answer_card_provider.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

class AnswerCard extends ConsumerWidget {
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isCorrect,
  });

  final QuizAnswer answer;
  final bool isCorrect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(answerCardExpandedProvider(answer.questionId));
    final stateNotifier =
        ref.read(answerCardExpandedProvider(answer.questionId).notifier);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnswerMainCard(
          answerText: answer.questionText,
          isCorrect: isCorrect,
          isExpanded: isExpanded,
          onTap: stateNotifier.toggle,
          isDarkMode: isDarkMode,
        ),
        AnswerExpandable(
          isExpanded: isExpanded,
          answer: answer,
        ),
      ],
    );
  }
}
