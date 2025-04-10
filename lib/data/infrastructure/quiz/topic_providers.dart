import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/topic/topic.dart';

part 'topic_providers.g.dart';

@riverpod
Future<List<Topic>> topics(
    Ref ref, String categoryId, String languageCode) async {
  final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
  return repo.getTopics(categoryId, languageCode);
}
