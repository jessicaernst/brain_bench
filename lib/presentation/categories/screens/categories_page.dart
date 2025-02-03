import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/providers/category_providers.dart';
import 'package:brain_bench/presentation/categories/widgets/category_button.dart';
import 'package:brain_bench/presentation/categories/widgets/category_row_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('CategoriesPage');

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final String languageCode = Localizations.localeOf(context).languageCode;
    logger.info('CategoriesPage initialized with languageCode: $languageCode');

    final AsyncValue<List<Category>> categoriesAsync =
        ref.watch(categoriesProvider(languageCode));

    final categoryNotifier =
        ref.read(selectedCategoryNotifierProvider.notifier);
    final String? selectedCategoryId =
        ref.watch(selectedCategoryNotifierProvider);

    void navigateToCategoryDetails(BuildContext context) {
      if (categoriesAsync is AsyncData<List<Category>>) {
        final categories = categoriesAsync.value;
        final selectedCategory = categories
                .where((category) => category.id == selectedCategoryId)
                .isNotEmpty
            ? categories
                .firstWhere((category) => category.id == selectedCategoryId)
            : null;

        if (selectedCategory != null) {
          logger.info('Navigating to category details: ${selectedCategory.id}');
          Navigator.pushNamed(
            context,
            '/categories/details',
            arguments: selectedCategory,
          );
        } else {
          logger.info('No category selected for navigation.');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appBarTitleCategories,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: categoriesAsync.when(
          data: (categories) {
            logger.info('Received ${categories.length} categories');

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categories.map((category) {
                        final isSelected = selectedCategoryId == category.id;
                        final categoryName = languageCode == 'de'
                            ? category.nameDe
                            : category.nameEn;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: CategoryRowView(
                            categoryId: category.id,
                            categoryTitle: categoryName,
                            progress: category.progress,
                            isSelected: isSelected,
                            onSelectedChanged: (bool selected) {
                              logger.info('Category selected: ${category.id}');
                              categoryNotifier.selectCategory(
                                  selected ? category.id : null);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CategoryButton(
                    title: localizations.chooseCategoryBtnLbl,
                    isActive: selectedCategoryId != null,
                    isDarkMode: isDarkMode,
                    onPressed: () => navigateToCategoryDetails(context),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
