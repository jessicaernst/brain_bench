import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/result.dart';

part 'result_providers.g.dart';

/// Provides a list of [Result] objects for a specific user.
///
/// This provider uses the [quizMockDatabaseRepositoryProvider] to fetch the
/// results from the mock database.
@riverpod
Future<List<Result>> results(Ref ref) {
  final repo = ref.watch(quizMockDatabaseRepositoryProvider);
  return repo.getResults('mock-user-1234'); // Mocked user ID
}

/// A notifier that handles saving quiz results and marking topics as done.
///
/// This notifier uses the [quizMockDatabaseRepositoryProvider] to interact
/// with the mock database.
@riverpod
class SaveResultNotifier extends _$SaveResultNotifier {
  /// Initializes the notifier.
  @override
  FutureOr<void> build() {}

  /// Saves a [Result] object to the mock database.
  ///
  /// This method uses the [quizMockDatabaseRepositoryProvider] to save the
  /// result.
  ///
  /// Parameters:
  ///   - [result]: The [Result] object to save.
  Future<void> saveResult(Result result) async {
    final repo = ref.read(quizMockDatabaseRepositoryProvider);
    await repo.saveResult(result);
  }

  /// Marks a topic as done in the mock database.
  ///
  /// This method uses the [quizMockDatabaseRepositoryProvider] to mark the
  /// topic as done.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to mark as done.
  Future<void> markTopicAsDone(String topicId) async {
    final repo = ref.read(quizMockDatabaseRepositoryProvider);
    await repo.markTopicAsDone(topicId);
  }
}
