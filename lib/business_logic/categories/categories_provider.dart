import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

Logger logger = Logger('CategoriesProvider');

@riverpod
class CategoryViewModel extends _$CategoryViewModel {
  String? _selectedCategoryId;

  @override
  Future<List<Category>> build(String languageCode) async {
    return await ref.watch(categoriesProvider(languageCode).future);
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    ref.invalidateSelf();
  }

  String? get selectedCategoryId => _selectedCategoryId;

  bool isCategorySelected() => _selectedCategoryId != null;

  Category? getSelectedCategory() {
    // Check if the current state is an AsyncData holding a List of Categories
    if (state is AsyncData<List<Category>>) {
      // Retrieve the currently selected category ID
      final selectedCategoryId = _selectedCategoryId;

      // Access the list of categories from the AsyncData state
      final categories = (state as AsyncData<List<Category>>).value;

      // Ensure that the list of categories is not empty
      if (categories.isNotEmpty) {
        // Find the category that matches the selectedCategoryId
        final matchingCategory =
            categories.where((category) => category.id == selectedCategoryId);

        // If a matching category exists, return the first one; otherwise, return null
        return matchingCategory.isNotEmpty ? matchingCategory.first : null;
      }
    }

    // If the state is not AsyncData or no matching category is found, return null
    return null;
  }

  void navigateToCategoryDetails(BuildContext context) {
    final selectedCategory = getSelectedCategory();
    if (selectedCategory != null) {
      logger.info(
          'Navigating to category details for category: $selectedCategory');
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
