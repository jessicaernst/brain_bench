import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/shared_widgets/progress_bars/dash_evolution_progress_dircle_view.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

/// A row widget that displays the actual category content.
class ActualCategoryContentRow extends StatelessWidget {
  const ActualCategoryContentRow({
    super.key,
    required this.displayedProgress,
    required this.dashSize,
    required this.displayedCategoryName,
    required this.displayedDescription,
    required this.descriptionMaxLines,
    required this.isDarkMode,
    required this.onSwitchCategoryPressed,
  });

  final double displayedProgress;
  final double dashSize;
  final String displayedCategoryName;
  final String displayedDescription;
  final int descriptionMaxLines;
  final bool isDarkMode;
  final VoidCallback onSwitchCategoryPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashEvolutionProgressCircleView(
            progress: displayedProgress,
            size: dashSize,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        displayedCategoryName,
                        style: Theme.of(context).textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.unfold_more,
                        size: 24,
                        color:
                            isDarkMode
                                ? BrainBenchColors.cloudCanvas.withAlpha(
                                  (0.8 * 255).toInt(),
                                )
                                : BrainBenchColors.deepDive.withAlpha(
                                  (0.8 * 255).toInt(),
                                ),
                      ),
                      tooltip: 'Switch category',
                      onPressed: onSwitchCategoryPressed,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AutoHyphenatingText(
                  displayedDescription,
                  maxLines: descriptionMaxLines,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
