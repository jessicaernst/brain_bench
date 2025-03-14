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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 Question Section
          const Text(
            'Question:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            answer.questionText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          // 🟡 Answer Section
          Column(
            children: answer.allAnswers.map((option) {
              final bool isSelected = answer.givenAnswers.contains(option);
              final bool isCorrect = answer.correctAnswers.contains(option);
              final bool isMissedCorrect =
                  !isSelected && isCorrect; // Verpasste richtige Antwort

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? (isCorrect
                              ? Icons.check_circle // ✅ Korrekte Auswahl
                              : Icons.cancel) // ❌ Falsche Auswahl
                          : (isMissedCorrect
                              ? Icons.info // ℹ️ Verpasste richtige Antwort
                              : Icons.radio_button_unchecked), // 🔘 Ungewählt
                      color: isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : (isMissedCorrect ? Colors.blue : Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontWeight: isSelected || isMissedCorrect
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isMissedCorrect
                                  ? Colors.blue
                                  : Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // 🔵 Explanation Section
          const Text(
            'Explanation:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            answer.explanation ?? 'Keine Erklärung verfügbar.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
