import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/answer.dart';

part 'answer_providers.g.dart';

Logger _logger = Logger('AnswerProviders');

@riverpod
Future<List<Answer>> answers(
    Ref ref, List<String> answerIds, String languageCode) async {
  final repo = ref.watch(mockDatabaseRepositoryProvider);
  final result = await repo.getAnswers(answerIds, languageCode);

  _logger.info('answersProvider liefert: ${result.length} Antworten');
  return result;
}
