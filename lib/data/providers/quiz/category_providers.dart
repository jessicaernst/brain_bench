import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

final Logger _logger = Logger('Categories');

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build(String languageCode) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    return repo.getCategories(languageCode);
  }

  Future<void> updateCategoryProgress(
    String categoryId,
    String languageCode,
    WidgetRef ref,
  ) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    final allTopics = await repo.getTopics(categoryId, languageCode);

    final double progress = _calculateCategoryProgress(allTopics);

    final appUser = await ref.read(currentUserProvider.future);
    final user = await repo.getUser(appUser!.uid);

    if (user == null) return;

    final updatedUser = user.copyWith(
      categoryProgress: {
        ...user.categoryProgress,
        categoryId: progress,
      },
    );

    await repo.updateUser(updatedUser);
    _logger.info('✅ categoryProgress aktualisiert für $categoryId: $progress');
  }

  // ✅ Helper method to calculate the category progress
  double _calculateCategoryProgress(List<Topic> topics) {
    if (topics.isEmpty) return 0.0;
    // ✅ Count only passed topics
    final int passedTopicsCount = topics.where((t) => t.isDone).length;
    return passedTopicsCount / topics.length;
  }
}
