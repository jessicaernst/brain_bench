import 'package:brain_bench/data/repositories/quiz_mock_database_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'database_providers.g.dart';

@riverpod
Future<QuizMockDatabaseRepository> quizMockDatabaseRepository(Ref ref) async {
  final directory = await getApplicationDocumentsDirectory();
  final resultsPath = '${directory.path}/results.json';
  final categoriesPath = '${directory.path}/category.json';
  final topicsPath = '${directory.path}/topics.json';
  final questionsPath = '${directory.path}/questions.json';
  final answersPath = '${directory.path}/answers.json';
  final userPath = '${directory.path}/user.json';

  final repo = QuizMockDatabaseRepository(
    resultsPath: resultsPath,
    categoriesPath: categoriesPath,
    topicsPath: topicsPath,
    questionsPath: questionsPath,
    answersPath: answersPath,
    userPath: userPath,
  );
  await repo.copyAssetsToDocuments();
  return repo;
}
