import 'dart:ui';

import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget that displays the expandable content for an answer in a quiz.
class AnswerExpandableContent extends HookConsumerWidget {
  const AnswerExpandableContent({
    super.key,
    required this.isExpanded,
    required this.answer,
  });

  final bool isExpanded;
  final QuizAnswer answer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎬 Animation Controller mit `useAnimationController()`
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    final heightFactor = useAnimation(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    final fadeAnimation =
        useAnimation(Tween<double>(begin: 0, end: 1).animate(controller));

    useEffect(() {
      if (isExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, [isExpanded]);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Align(
            heightFactor: heightFactor,
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: fadeAnimation,
              duration: const Duration(milliseconds: 300),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.1, 1.0],
                        colors: [
                          BrainBenchColors.flutterSky.withAlpha(0),
                          BrainBenchColors.flutterSky.withAlpha(51),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.1, 1.0],
                        colors: [
                          BrainBenchColors.blueprintBlue.withAlpha(0),
                          BrainBenchColors.blueprintBlue.withAlpha(51),
                        ],
                      ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
