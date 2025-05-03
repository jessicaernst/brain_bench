import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/component_widgets/dash_evolution_progress_dircle_view.dart';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 16.0),
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DashEvolutionProgressCircleView(
                progress: 0.75,
                size: 118,
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
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
