import 'package:brain_bench/data/infrastructure/database_repository_providers.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:brain_bench/data/repositories/quiz_firebase_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_firebase_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

final Logger _logger = Logger('QuizFirebaseRepository');

@riverpod
UserRepository userFirebaseRepository(Ref ref) {
  return UserFirebaseRepositoryImpl(firestore: firestore(ref));
}

@riverpod
DatabaseRepository quizFirebaseRepository(Ref ref) {
  return QuizFirebaseRepositoryImpl(firestore: firestore(ref));
}

@riverpod
Future<void> initialDataLoad(Ref ref, String userId) async {
  final repo = ref.read(quizFirebaseRepositoryProvider);

  try {
    final categories = await repo.getCategories();

    for (final category in categories) {
      final topics = await repo.getTopics(category.id);

      for (final topic in topics) {
        final questions = await repo.getQuestions(topic.id);

        for (final question in questions) {
          if (question.answerIds.isNotEmpty) {
            await repo.getAnswers(question.answerIds);
          }
        }
      }
    }

    await repo.getResults(userId);

    _logger.info('Initial data load complete for user: $userId');
  } catch (e) {
    _logger.severe('Error during initial data load for user $userId: $e');
    rethrow;
  }
}
