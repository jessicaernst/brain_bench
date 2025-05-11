import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

Logger logger = Logger('CategoriesProvider');

@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  @override
  String? build() => null;

  void selectCategory(String? categoryId) {
    if (state == categoryId) {
      state = null;
      logger.info('🛑 Category deselected.');
    } else {
      state = categoryId;
      logger.info('✅ Category selected: $categoryId');
    }

    Future.microtask(() {
      logger.info('🔄 Updated selectedCategoryId: $state');
    });
  }

  bool isCategorySelected() => state != null;
}

@riverpod
Future<Category> categoryById(
  Ref ref,
  String categoryId,
  String languageCode,
) async {
  logger.info(
    '🔄 Fetching category by ID: $categoryId for language: $languageCode',
  );
  final categories = await ref.watch(categoriesProvider(languageCode).future);
  try {
    final category = categories.firstWhere(
      (category) => category.id == categoryId,
    );
    logger.info('✅ Category found: ${category.nameEn}');
    return category;
  } catch (e) {
    logger.severe('❌ Category not found for ID: $categoryId');
    rethrow;
  }
}
