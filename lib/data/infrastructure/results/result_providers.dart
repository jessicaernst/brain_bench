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
  final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
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
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    await repo.saveResult(result);
  }

  /// Marks a topic as done and updates user progress.
  Future<void> markTopicAsDone({
    required String topicId,
    required String categoryId,
  }) async {
    final quizRepo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    final userRepo = await ref.watch(userRepositoryProvider.future);
    final state = await ref.watch(currentUserModelProvider.future);

    final user = switch (state) {
      UserModelData(:final user) => user,
      _ => throw Exception('❌ Kein eingeloggter User in markTopicAsDone'),
    };

    // Step 1: Mark topic as done in the quiz repository
    await quizRepo.markTopicAsDone(topicId, categoryId, user.uid);

    // Step 2: Update user's progress (isTopicDone and categoryProgress)
    // This logic was previously in QuizMockDatabaseRepositoryImpl.markTopicAsDone

    // Update user.isTopicDone
    final updatedIsTopicDone = {
      ...user.isTopicDone,
      categoryId: {...(user.isTopicDone[categoryId] ?? {}), topicId: true},
    };

    // Calculate new progress for the category
    // This requires fetching topics for the category from quizRepo
    final topicsForCategory = await quizRepo.getTopics(categoryId);
    final passedCount =
        topicsForCategory
            .where((topic) => updatedIsTopicDone[categoryId]?[topic.id] == true)
            .length;
    final progress =
        topicsForCategory.isEmpty
            ? 0.0
            : passedCount / topicsForCategory.length;

    final updatedCategoryProgress = {
      ...user.categoryProgress,
      categoryId: progress,
    };

    // Update the user in the user repository
    await userRepo.updateUser(
      user.copyWith(
        isTopicDone: updatedIsTopicDone,
        categoryProgress: updatedCategoryProgress,
      ),
    );

    // Invalidate currentUserModelProvider to reflect changes
    ref.invalidate(currentUserModelProvider);
  }
}
