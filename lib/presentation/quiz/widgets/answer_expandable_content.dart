import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class AnswerExpandableContent extends StatelessWidget {
  const AnswerExpandableContent({
    super.key,
    required this.isExpanded,
    required this.answer,
  });

  final bool isExpanded;
  final QuizAnswer answer;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.1, 1.0],
                        colors: [
                          BrainBenchColors.flutterSky
                              .withAlpha((0.0 * 255).toInt()),
                          BrainBenchColors.flutterSky
                              .withAlpha((0.2 * 255).toInt()),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 1.0],
                        colors: [
                          BrainBenchColors.blueprintBlue
                              .withAlpha((0.0 * 255).toInt()),
                          BrainBenchColors.blueprintBlue
                              .withAlpha((0.2 * 255).toInt()),
                        ],
                      ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                      style: const TextStyle(color: BrainBenchColors.deepDive),
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
            ),
          ),
        ),
      ),
    );
  }
}
