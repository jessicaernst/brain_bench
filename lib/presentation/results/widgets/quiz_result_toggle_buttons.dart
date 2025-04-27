import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/presentation/results/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizResultToggleButtons extends ConsumerWidget {
  const QuizResultToggleButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizResultNotifierProvider);
    final notifier = ref.read(quizResultNotifierProvider.notifier);

    final hasCorrect = notifier.hasCorrectAnswers();
    final hasIncorrect = notifier.hasIncorrectAnswers();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButton(
            isSelected: state.selectedView == SelectedView.correct,
            icon: Icons.thumb_up,
            isCorrect: true,
            isActive: hasCorrect,
            onTap: () => notifier.toggleView(SelectedView.correct),
          ),
          const SizedBox(width: 48),
          ToggleButton(
            isSelected: state.selectedView == SelectedView.incorrect,
            icon: Icons.thumb_down,
            isCorrect: false,
            isActive: hasIncorrect,
            onTap: () => notifier.toggleView(SelectedView.incorrect),
          ),
        ],
      ),
    );
  }
}
