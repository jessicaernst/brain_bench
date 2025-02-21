import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.isCorrect,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final bool isCorrect; // Entscheidet zwischen korrekt/falsch
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isSelected ? 110 : 90,
        height: isSelected ? 110 : 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCorrect
                ? [
                    BrainBenchColors.correctAnswerGlass
                        .withAlpha((0.4 * 255).toInt()),
                    BrainBenchColors.correctAnswerGlass
                        .withAlpha((0.1 * 255).toInt())
                  ]
                : [
                    BrainBenchColors.falseQuestionGlass
                        .withAlpha((0.4 * 255).toInt()),
                    BrainBenchColors.falseQuestionGlass
                        .withAlpha((0.1 * 255).toInt())
                  ],
            stops: const [0.0, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            isCorrect
                ? CupertinoIcons.hand_thumbsup_fill
                : CupertinoIcons.hand_thumbsdown_fill,
            color: TextTheme.of(context).bodySmall!.color,
            size: isSelected ? 50 : 40,
          ),
        ),
      ),
    );
  }
}
