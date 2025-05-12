import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

final Logger _logger = Logger('Categories');

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build(String languageCode) async {
    // Use the notifier's 'ref' to watch dependencies
    final repo = await ref.watch(quizMockDatabaseRepositoryProvider.future);
    _logger.finer('Fetching categories for language: $languageCode');
    final categories = await repo.getCategories();
    _logger.finer('Fetched ${categories.length} categories.');
    return categories;
  }

  Future<void> updateCategoryProgress(
    String categoryId,
    String languageCode,
    // WidgetRef ref, // <-- PARAMETER REMOVED
  ) async {
    // Use the notifier's 'ref' to read dependencies
    final QuizMockDatabaseRepository repo = await ref.read(
      quizMockDatabaseRepositoryProvider.future,
    );
    final AppUser? appUser = await ref.read(
      currentUserProvider.future,
    ); // Read current user state

    if (appUser == null) {
      _logger.warning('Cannot update category progress: currentUser is null.');
      return; // Exit if no authenticated user
    }

    _logger.finer(
      'Updating progress for category $categoryId, user ${appUser.uid}',
    );

    try {
      // Fetch necessary data using the repository
      final List<Topic> allTopics = await repo.getTopics(categoryId);
      final AppUser? user = await repo.getUser(
        appUser.uid,
      ); // Fetch user data from DB

      if (user == null) {
        _logger.warning(
          'Cannot update category progress: User ${appUser.uid} not found in DB.',
        );
        return; // Exit if user data not found in DB
      }

      // Calculate progress using the helper method
      final double progress = _calculateCategoryProgress(
        allTopics,
        user,
        categoryId,
      );

      // Create the updated user object
      final updatedUser = user.copyWith(
        categoryProgress: {
          ...user
              .categoryProgress, // Preserve existing progress for other categories
          categoryId: progress, // Update progress for the current category
        },
      );

      // Save the updated user data
      await repo.updateUser(updatedUser);
      _logger.info(
        '✅ Category progress updated for $categoryId: $progress',
      ); // Log in English
    } catch (e, s) {
      _logger.severe(
        '❌ Error updating category progress for $categoryId',
        e,
        s,
      );
      // Re-throw the exception so the caller (e.g., UI) can handle it if needed
      rethrow;
    }
  }

  // Helper method remains the same
  double _calculateCategoryProgress(
    List<Topic> topics,
    AppUser user,
    String categoryId,
  ) {
    if (topics.isEmpty) {
      _logger.finer(
        'No topics found for category $categoryId, progress is 0.0',
      );
      return 0.0;
    }

    final topicDoneMap = user.isTopicDone[categoryId] ?? {};
    final int passedTopicsCount =
        topics.where((t) => topicDoneMap[t.id] == true).length;
    final progress = passedTopicsCount / topics.length;
    _logger.finer(
      'Calculated progress for $categoryId: $passedTopicsCount / ${topics.length} = $progress',
    );
    return progress;
  }
}
