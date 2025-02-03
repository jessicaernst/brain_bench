import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/widgets/darkmode_btn.dart';
import 'package:brain_bench/core/widgets/lightmode_btn.dart';
import 'package:brain_bench/data/models/category.dart';
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

    final AsyncValue<List<Category>> categoryViewModel =
        ref.watch(categoryViewModelProvider(languageCode));
    final categoryNotifier =
        ref.read(categoryViewModelProvider(languageCode).notifier);

    final bool isCategorySelected = categoryNotifier.isCategorySelected();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appBarTitleCategories,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: categoryViewModel.when(
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
                        final isSelected = categoryNotifier
                                .isCategorySelected() &&
                            categoryNotifier.selectedCategoryId == category.id;
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
                  child: isDarkMode
                      ? LightmodeBtn(
                          title: localizations.chooseCategoryBtnLbl,
                          onPressed: isCategorySelected
                              ? () {
                                  logger.info('Category selected');
                                }
                              : () {
                                  logger.info('Button inactive');
                                },
                          isActive: isCategorySelected,
                        )
                      : DarkmodeBtn(
                          title: localizations.chooseCategoryBtnLbl,
                          onPressed: isCategorySelected
                              ? () {
                                  logger.info('Category selected');
                                }
                              : () {
                                  logger.info('Button inactive');
                                },
                          isActive: isCategorySelected,
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
