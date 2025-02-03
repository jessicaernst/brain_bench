import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/categories/widgets/progress_evolution_image_view.dart';
import 'package:flutter/material.dart';

class CategoryRowView extends StatelessWidget {
  const CategoryRowView({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.progress,
    required this.isSelected,
    required this.onSelectedChanged,
  });

  final String categoryId;
  final String categoryTitle;
  final double progress;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color selectedColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.blueprintBlue;

    return GestureDetector(
      onTap: () => onSelectedChanged(!isSelected),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            ProgessEvolutionImageView(
              progress: progress,
            ),
            Text(
              categoryTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isSelected
                        ? selectedColor
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
