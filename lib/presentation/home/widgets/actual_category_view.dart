import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/component_widgets/dash_evolution_progress_dircle_view.dart';
import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

class ActualCategoryView extends StatelessWidget {
  const ActualCategoryView({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreenValue = context.isSmallScreen;

    final double dashSize = isSmallScreenValue ? 90 : 118;
    final double verticalSpacing = isSmallScreenValue ? 8 : 16;
    final int descriptionMaxLines = isSmallScreenValue ? 2 : 3;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: verticalSpacing),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'actual',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? BrainBenchColors.cloudCanvas
                            .withAlpha((0.6 * 255).toInt())
                        : BrainBenchColors.deepDive
                            .withAlpha((0.6 * 255).toInt()),
                  ),
            ),
          ),
        ),
        SizedBox(height: verticalSpacing),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DashEvolutionProgressCircleView(
                progress: 0.75,
                size: dashSize,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'test category',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    AutoHyphenatingText(
                      'Potter ipsum wand elf parchment wingardium. Heir long description that needs to wrap automatically when space runs out.',
                      maxLines: descriptionMaxLines,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
