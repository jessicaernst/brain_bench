import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/question.dart';

part 'question_providers.g.dart';

@riverpod
Future<List<Question>> questions(Ref ref, String topicId, String languageCode) {
  final repo = ref.watch(quizMockDatabaseRepositoryProvider);
  return repo.getQuestions(topicId, languageCode);
}
