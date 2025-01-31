import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/answer.dart';

part 'answer_providers.g.dart';

@riverpod
Future<List<Answer>> answers(
    Ref ref, List<String> answerIds, String languageCode) {
  final repo = ref.watch(mockDatabaseRepositoryProvider);
  return repo.getAnswers(answerIds, languageCode);
}
