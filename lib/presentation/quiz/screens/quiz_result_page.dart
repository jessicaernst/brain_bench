import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/core/widgets/back_nav_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizResultPage extends ConsumerWidget {
  const QuizResultPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);

    return Scaffold(
      appBar: BackNavAppBar(
          title: 'Quiz Ergebnisse',
          onBack: () {
            context.go(
              '/categories',
              extra: categoryId,
            );
          }),
      body: quizAnswers.isEmpty
          ? const Center(child: Text('Keine Antworten gespeichert.'))
          : ListView.builder(
              itemCount: quizAnswers.length,
              itemBuilder: (context, index) {
                final answer = quizAnswers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          answer.questionText,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Deine Antwort(en): ${answer.givenAnswers.join(", ")}",
                          style: TextStyle(
                              color: answer.incorrectAnswers.isEmpty
                                  ? Colors.green
                                  : Colors.red),
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
                    ),
                  ),
                );
              },
            ),
    );
  }
}
