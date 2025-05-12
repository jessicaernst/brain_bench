import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_providers.g.dart';

@riverpod
Future<List<Question>> questions(Ref ref, String topicId) async {
  final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
  return repo.getQuestions(topicId);
}
