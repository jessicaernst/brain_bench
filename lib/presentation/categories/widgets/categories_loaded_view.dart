import 'package:brain_bench/business_logic/categories/categories_provider.dart'; // Assuming selectedCategoryNotifierProvider is here
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/component_widgets/profile_button_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/presentation/categories/widgets/category_row_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('CategoriesLoadedView');

class CategoriesLoadedView extends ConsumerWidget {
  final List<Category> categories;
  final AppLocalizations localizations;
  final String languageCode;

  const CategoriesLoadedView({
    super.key,
    required this.categories,
    required this.localizations,
    required this.languageCode,
  });

  // Helper to build a single category row widget
  Widget _buildCategoryRow(Category category, AppUser? user) {
    final categoryName =
        languageCode == 'de' ? category.nameDe : category.nameEn;
    final progress = user?.categoryProgress[category.id] ?? 0.0;

    return Padding(
      key: ValueKey(category.id),
      padding: const EdgeInsets.only(bottom: 32),
      child: CategoryRowView(
        categoryId: category.id,
        categoryTitle: categoryName,
        progress: progress,
      ),
    );
  }

  // --- Extracted Function for the map operation ---
  // This function needs access to 'user', so it remains a method.
  // It takes the item from the list (category) and returns the widget.
  Widget _mapCategoryToWidget(Category category, AppUser? user) {
    return _buildCategoryRow(category, user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryNotifierProvider);
    _logger.fine('Watching selectedCategoryId: $selectedCategoryId');
    final AppUser? user = ref.watch(currentUserModelProvider).valueOrNull;

    void handleChooseCategoryPressed() {
      if (selectedCategoryId != null) {
        try {
          final selectedCategory = categories.firstWhere(
            (category) => category.id == selectedCategoryId,
          );
          _logger.info(
              'Navigating to category details for categoryId: ${selectedCategory.id}');
          context.push('/categories/details', extra: selectedCategory);
        } catch (e) {
          _logger.severe('Error finding selected category: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.errorCategoryNotFound),
            ),
          );
        }
      } else {
        _logger.warning('No category selected for navigation.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.errorNoCategorySelected),
          ),
        );
      }
    }

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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        actions: const [
          ProfileButtonView(),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories
                      .map((category) => _mapCategoryToWidget(category, user))
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LightDarkSwitchBtn(
              title: localizations.chooseCategoryBtnLbl,
              isActive: selectedCategoryId != null,
              onPressed: handleChooseCategoryPressed,
            ),
          ),
        ],
      ),
    );
  }
}
