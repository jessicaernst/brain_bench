import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_providers.g.dart';

/// Provides a list of [Result] objects for the currently logged-in user.
@riverpod
Future<List<Result>> results(Ref ref) async {
  final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
  final user = await ref.watch(currentUserModelProvider.future);

  if (user == null) {
    throw Exception('❌ Kein eingeloggter User in [resultsProvider]');
  }

  return repo.getResults(user.uid);
}

/// A notifier that handles saving quiz results and marking topics as done.
@riverpod
class SaveResultNotifier extends _$SaveResultNotifier {
  @override
  FutureOr<void> build() {}

  /// Saves a [Result] object to the database.
  Future<void> saveResult(Result result) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    await repo.saveResult(result);
  }

  /// Marks a topic as done and updates user progress.
  Future<void> markTopicAsDone({
    required String topicId,
    required String categoryId,
  }) async {
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    // Await the future to get the current user data.
    // The complete user object is needed for the repository call to update progress.
    final user = await ref.watch(currentUserModelProvider.future);

    if (user == null) {
      throw Exception('❌ Kein eingeloggter User in markTopicAsDone');
    }

    await repo.markTopicAsDone(topicId, categoryId, user);

    ref.invalidate(currentUserModelProvider);
  }
}
