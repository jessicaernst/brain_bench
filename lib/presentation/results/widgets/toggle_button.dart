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
  });

  final bool isSelected;
  final IconData icon;
  final bool isCorrect;
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
          gradient: isCorrect
              ? BrainBenchGradients.correctAnswerGlass
              : BrainBenchGradients.falseQuestionGlass,
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
