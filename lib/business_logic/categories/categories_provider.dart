import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/providers/category_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

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
}
