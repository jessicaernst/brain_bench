import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/providers/category_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

Logger logger = Logger('CategoriesProvider');

@riverpod
Future<List<Category>> build(Ref ref, String languageCode) async {
  return await ref.watch(categoriesProvider(languageCode).future);
}

@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  @override
  String? build() => null;

  void selectCategory(String? categoryId) {
    state = categoryId;
  }

  bool isCategorySelected() => state != null;
}
