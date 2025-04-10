import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/presentation/categories/widgets/category_row_view.dart';
import 'package:brain_bench/presentation/home/widgets/profile_button_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

Logger _logger = Logger('CategoriesPage');

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;

    // Fetch categories using the provider
    final categoriesAsync = ref.watch(categoriesProvider(languageCode));

    // Watch selectedCategoryId for button state
    final selectedCategoryId = ref.watch(selectedCategoryNotifierProvider);
    _logger.info('🔄 Watching selectedCategoryId: $selectedCategoryId');

    // Ensure categories are loaded only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoriesAsync.whenData((categories) {
        if (categories.isEmpty) {
          _logger.info('Loading categories for language: $languageCode');
          ref.read(categoriesProvider(languageCode));
        }
      });
    });

    return categoriesAsync.when(
      data: (categories) {
        _logger.info(
            'Categories loaded successfully. Total: ${categories.length}');
        final user = ref.watch(currentUserModelProvider).valueOrNull;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            title: const SizedBox(),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 56),
              child: Center(
                child: Text(
                  localizations.appBarTitleCategories,
                  style: TextTheme.of(context).headlineSmall,
                ),
              ),
            ),
            actions: const [
              // Dropdown Menu for Profile/Settings/Logout
              ProfileButtonView(),
              SizedBox(width: 16),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.map((category) {
                      final categoryName = languageCode == 'de'
                          ? category.nameDe
                          : category.nameEn;

                      final progress =
                          user?.categoryProgress[category.id] ?? 0.0;

                      return Padding(
                        key: ValueKey(category.id),
                        padding: const EdgeInsets.only(bottom: 32),
                        child: CategoryRowView(
                          categoryId: category.id,
                          categoryTitle: categoryName,
                          progress: progress,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LightDarkSwitchBtn(
                  title: localizations.chooseCategoryBtnLbl,
                  // depends on selectedCategoryId
                  isActive: selectedCategoryId != null,
                  onPressed: () {
                    if (selectedCategoryId != null) {
                      final selectedCategory = categories.firstWhere(
                        (category) => category.id == selectedCategoryId,
                      );
                      _logger.info(
                          'Navigating to category details for categoryId: ${selectedCategory.id}');

                      // ✅ Übergebe das gesamte Category-Objekt
                      context.go('/categories/details',
                          extra: selectedCategory);
                    } else {
                      _logger.warning('No category selected for navigation.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a category first.'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        _logger.info('Loading categories...');
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        _logger.severe('Error loading categories: $error');
        return Scaffold(
          body: Center(child: Text('Error: ${error.toString()}')),
        );
      },
    );
  }
}
