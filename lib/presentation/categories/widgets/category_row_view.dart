import 'package:brain_bench/business_logic/categories/categories_view_model.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/categories/widgets/progress_evolution_image_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('CategoryRowView');

class CategoryRowView extends HookConsumerWidget {
  const CategoryRowView({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.progress,
  });

  final String categoryId;
  final String categoryTitle;
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(categoriesViewModelProvider).selectedCategoryId == categoryId;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.blueprintBlue;

    return GestureDetector(
      onTap: () {
        final notifier = ref.read(categoriesViewModelProvider.notifier);
        notifier.selectCategory(isSelected ? null : categoryId);
      },
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
    );
  }
}
