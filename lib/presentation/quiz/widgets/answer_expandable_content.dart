import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:flutter/material.dart';

class AnswerExpandableContent extends StatelessWidget {
  const AnswerExpandableContent({
    super.key,
    required this.answer,
  });

  final QuizAnswer answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Erklärung:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Keine Erklärung verfügbar.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Text(
          "Deine Antwort(en): ${answer.givenAnswers.join(", ")}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "Richtige Antwort(en): ${answer.correctAnswers.join(", ")}",
          style: const TextStyle(color: Colors.green),
        ),
        if (answer.incorrectAnswers.isNotEmpty)
          Text(
            "Falsche Antwort(en): ${answer.incorrectAnswers.join(", ")}",
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
