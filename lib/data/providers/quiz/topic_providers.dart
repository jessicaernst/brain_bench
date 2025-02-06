import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/topic.dart';

part 'topic_providers.g.dart';

@riverpod
Future<List<Topic>> topics(Ref ref, String categoryId, String languageCode) {
  final repo = ref.watch(quizMockDatabaseRepositoryProvider);
  return repo.getTopics(categoryId, languageCode);
}
