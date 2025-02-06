import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/result.dart';

part 'result_providers.g.dart';

@riverpod
Future<List<Result>> results(Ref ref) {
  final repo = ref.watch(quizMockDatabaseRepositoryProvider);
  return repo.getResults('mock-user-1234'); // Mocked user ID
}

@riverpod
class SaveResultNotifier extends _$SaveResultNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> saveResult(Result result) async {
    final repo = ref.read(quizMockDatabaseRepositoryProvider);
    await repo.saveResult(result);
  }
}
