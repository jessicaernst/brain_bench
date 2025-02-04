import 'package:brain_bench/data/providers/category_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:brain_bench/data/models/category.dart';

part 'categories_view_model.g.dart';

@riverpod
class CategoriesViewModel extends _$CategoriesViewModel {
  @override
  CategoriesState build() {
    return const CategoriesState();
  }

  Future<void> loadCategories(String languageCode, WidgetRef ref) async {
    state = state.copyWith(isLoading: true);
    try {
      final categories =
          await ref.read(categoriesProvider(languageCode).future);
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void navigateToCategoryDetails(BuildContext context) {
    final selectedCategory = state.categories.firstWhere(
      (category) => category.id == state.selectedCategoryId,
      orElse: () => Category(
          id: '',
          nameDe: '',
          nameEn: '',
          descriptionDe: '',
          descriptionEn: '',
          subtitleDe: '',
          subtitleEn: '',
          progress: 0.0),
    );

    if (selectedCategory.id.isNotEmpty) {
      Navigator.of(context).pushNamed(
        '/categories/details',
        arguments: selectedCategory,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category first.')),
      );
    }
  }
}

@immutable
class CategoriesState {
  final List<Category> categories;
  final String? selectedCategoryId;
  final bool isLoading;
  final String? errorMessage;

  const CategoriesState({
    this.categories = const [],
    this.selectedCategoryId,
    this.isLoading = false,
    this.errorMessage,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    String? selectedCategoryId,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
