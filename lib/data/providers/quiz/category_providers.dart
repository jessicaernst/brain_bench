import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

@riverpod
Future<List<Category>> categories(Ref ref, String languageCode) async {
  final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
  return repo.getCategories(languageCode);
}
