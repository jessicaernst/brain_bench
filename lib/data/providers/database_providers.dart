import 'package:brain_bench/data/repositories/quiz_mock_database_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@riverpod
QuizMockDatabaseRepository quizMockDatabaseRepository(Ref ref) {
  return QuizMockDatabaseRepository();
}
