import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class QuizResultHeader extends StatelessWidget {
  const QuizResultHeader({
    super.key,
    required this.isVisible,
    required this.userPoints,
    required this.totalPoints,
    required this.percentage,
    required this.isPassed,
    required this.localizations,
  });

  final bool isVisible;
  final int userPoints;
  final int totalPoints;
  final double percentage;
  final bool isPassed;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child:
          isVisible
              ? Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(
                        '${localizations.quizResultScore}: $userPoints / $totalPoints\n${percentage.toStringAsFixed(1)}%',
                        style: BrainBenchTextStyles.title1(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isPassed
                            ? localizations.quizResultPassed
                            : localizations.quizResultFailed,
                        style: BrainBenchTextStyles.title2Bold().copyWith(
                          color:
                              isPassed
                                  ? BrainBenchColors.correctAnswerGlass
                                  : BrainBenchColors.falseQuestionGlass,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : const SizedBox(height: 0),
    );
  }
}
