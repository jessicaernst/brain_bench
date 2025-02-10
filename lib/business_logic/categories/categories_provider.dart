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
