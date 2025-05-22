import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_providers.g.dart';

/// Provides a list of [Result] objects for the currently logged-in user.
@riverpod
@riverpod
Future<List<Result>> results(Ref ref) async {
  final repo = ref.watch(quizFirebaseRepositoryProvider);
  final state = await ref.watch(currentUserModelProvider.future);

  final user = switch (state) {
    UserModelData(:final user) => user,
    _ => throw Exception('❌ Kein eingeloggter User in [resultsProvider]'),
  };

  return repo.getResults(user.uid);
}

/// A notifier that handles saving quiz results and marking topics as done.
@riverpod
class SaveResultNotifier extends _$SaveResultNotifier {
  @override
  FutureOr<void> build() {}

  /// Saves a [Result] object to the database.
  Future<void> saveResult(Result result) async {
    final repo = ref.watch(quizFirebaseRepositoryProvider);
    await repo.saveResult(result);
  }

  /// Marks a topic as done and updates user progress.
  Future<void> markTopicAsDone({
    required String topicId,
    required String categoryId,
    required String userId, // Add userId as a parameter
  }) async {
    final quizRepo = ref.watch(quizFirebaseRepositoryProvider);
    final userRepo = ref.watch(userFirebaseRepositoryProvider);

    // Fetch topics for the category to pass to the user repository
    final topicsForCategory = await quizRepo.getTopics(categoryId);

    await userRepo.markTopicAsDone(
      userId: userId, // Use the passed userId
      topicId: topicId,
      categoryId: categoryId,
      topicsForCategory: topicsForCategory,
    );

    // Invalidate currentUserModelProvider to reflect changes
    ref.invalidate(currentUserModelProvider);
  }
}
