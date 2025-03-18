import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.isCorrect,
    required this.onTap,
    this.isActive = true,
  });

  final bool isSelected;
  final IconData icon;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isSelected ? 110 : 90,
        height: isSelected ? 110 : 90,
        decoration: BoxDecoration(
          gradient: isActive
              ? (isCorrect
                  ? BrainBenchGradients.correctAnswerGlass
                  : BrainBenchGradients.falseQuestionGlass)
              : null,
          color: isActive
              ? null
              : isDark
                  ? BrainBenchColors.inactiveGrayLight10
                  : BrainBenchColors.inactiveGray20,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            isCorrect
                ? CupertinoIcons.hand_thumbsup_fill
                : CupertinoIcons.hand_thumbsdown_fill,
            color: isActive
                ? TextTheme.of(context).bodySmall!.color
                : TextTheme.of(context)
                    .bodySmall!
                    .color
                    ?.withAlpha((0.2 * 255).toInt()),
            size: isSelected ? 50 : 40,
          ),
        ),
      ),
    );
  }
}
