import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build(String languageCode) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    return repo.getCategories(languageCode);
  }

  Future<void> updateCategoryProgress(
      String categoryId, double progress) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    final categories = await future;
    final categoryIndex =
        categories.indexWhere((category) => category.id == categoryId);
    if (categoryIndex != -1) {
      final updatedCategory =
          categories[categoryIndex].copyWith(progress: progress);
      categories[categoryIndex] = updatedCategory;
      state = AsyncData([...categories]);
      repo.updateCategory(updatedCategory);
    }
  }
}
