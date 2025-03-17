import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

class AnswerMainCard extends StatelessWidget {
  const AnswerMainCard({
    super.key,
    required this.answerText,
    required this.isCorrect,
    required this.onTap,
    required this.isExpanded,
    required this.isDarkMode,
  });

  final String answerText;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool isExpanded;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? BrainBenchGradients.answerCardDarkGradient
                  : BrainBenchGradients.answerCardLightGradient,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect
                      ? CupertinoIcons.hand_thumbsup_fill
                      : CupertinoIcons.hand_thumbsdown_fill,
                  color: TextTheme.of(context).bodySmall!.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    answerText,
                    style: TextTheme.of(context).bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
