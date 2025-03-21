import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
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
      String categoryId, String languageCode) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    final categories = await future;
    final categoryIndex =
        categories.indexWhere((category) => category.id == categoryId);
    if (categoryIndex != -1) {
      // ✅ Fetch all topics for the category from the repository
      final allTopics = await repo.getTopics(categoryId, languageCode);

      // ✅ Calculate the progress based on all topics
      final double progress = _calculateCategoryProgress(allTopics);

      final updatedCategory =
          categories[categoryIndex].copyWith(progress: progress);
      categories[categoryIndex] = updatedCategory;
      state = AsyncData([...categories]);
      repo.updateCategory(updatedCategory);
    }
  }

  // ✅ Helper method to calculate the category progress
  double _calculateCategoryProgress(List<Topic> topics) {
    if (topics.isEmpty) return 0.0;
    // ✅ Count only passed topics
    final int passedTopicsCount = topics.where((t) => t.isDone).length;
    return passedTopicsCount / topics.length;
  }
}
