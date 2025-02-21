import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isExpanded,
    required this.onExpand,
  });

  final QuizAnswer answer;
  final bool isExpanded;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(answer.questionText,
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: onExpand,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                spacing: 16,
                children: [
                  const Text(
                    'Keine Erklärung verfügbar.',
                  ),
                  Text(
                    "Deine Antwort(en): ${answer.givenAnswers.join(", ")}",
                  ),
                  Text(
                    "Richtige Antwort(en): ${answer.correctAnswers.join(", ")}",
                  ),
                  if (answer.incorrectAnswers.isNotEmpty)
                    Text(
                      "Falsche Antwort(en): ${answer.incorrectAnswers.join(", ")}",
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
