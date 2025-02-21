import 'package:brain_bench/business_logic/quiz/answer_card_provider.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnswerCard extends HookConsumerWidget {
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
    final notifier =
        ref.read(answerCardExpandedProvider(answer.questionId).notifier);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: notifier.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? BrainBenchGradients.answerCardDarkGradient
              : BrainBenchGradients.answerCardLightGradient,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                spacing: 8,
                children: [
                  Icon(
                    isCorrect
                        ? CupertinoIcons.hand_thumbsup_fill
                        : CupertinoIcons.hand_thumbsdown_fill,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                  Expanded(
                    child: Text(
                      answer.questionText,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.expand_more),
              ),
            ),
            if (isExpanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Keine Erklärung verfügbar.'),
                    const SizedBox(height: 8),
                    Text(
                        "Deine Antwort(en): ${answer.givenAnswers.join(", ")}"),
                    Text(
                        "Richtige Antwort(en): ${answer.correctAnswers.join(", ")}"),
                    if (answer.incorrectAnswers.isNotEmpty)
                      Text(
                          "Falsche Antwort(en): ${answer.incorrectAnswers.join(", ")}"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
