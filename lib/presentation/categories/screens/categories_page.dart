import 'package:brain_bench/business_logic/categories/categories_view_model.dart';
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
    final viewModel = ref.watch(categoriesViewModelProvider.notifier);
    final state = ref.watch(categoriesViewModelProvider);

    // Load categories during the initial rendering of the widget.
    // `addPostFrameCallback` ensures that the callback is executed
    // after the first frame is rendered, avoiding unnecessary rebuilds.
    // This is used to trigger the loading of categories if they are not already loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the categories are not already being loaded (`!state.isLoading`)
      // and the categories list is empty (`state.categories.isEmpty`).
      // If both conditions are true, trigger the `loadCategories` method
      // from the ViewModel to fetch the categories from the backend or local storage.
      if (!state.isLoading && state.categories.isEmpty) {
        viewModel.loadCategories(languageCode, ref);
      }
    });

    // Show a loading indicator if the `isLoading` flag in the state is true.
    // This happens while the categories are being fetched.
    // The user sees a centered CircularProgressIndicator to indicate the loading process.
    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If there is an error during the loading process, display the error message
    // from the `state.errorMessage` property. This prevents the app from crashing
    // and gives feedback to the user about the issue.
    if (state.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${state.errorMessage}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          localizations.appBarTitleCategories,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.categories.map((category) {
                    final isSelected = state.selectedCategoryId == category.id;
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
                          viewModel
                              .selectCategory(selected ? category.id : null);
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
                isActive: state.selectedCategoryId != null,
                isDarkMode: isDarkMode,
                onPressed: () => viewModel.navigateToCategoryDetails(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
