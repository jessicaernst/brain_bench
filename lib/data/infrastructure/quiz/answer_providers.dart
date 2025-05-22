import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'answer_providers.g.dart';

Logger _logger = Logger('AnswerProviders');

@riverpod
Future<List<Answer>> answers(Ref ref, List<String> answerIds) async {
  final repo = ref.watch(quizFirebaseRepositoryProvider);
  final result = await repo.getAnswers(answerIds);

  _logger.info('answersProvider liefert: ${result.length} Antworten');
  return result;
}
