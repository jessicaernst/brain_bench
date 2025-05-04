import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart'; // Import AuthRepository provider
import 'package:brain_bench/data/infrastructure/database_providers.dart'; // Keep DB provider import
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'user_provider.g.dart';

final Logger _logger = Logger('UserProvider');

@riverpod
Stream<model.AppUser?> currentUserModel(Ref ref) {
  // Watch the AuthRepository provider to get access to its instance
  final authRepository = ref.watch(authRepositoryProvider);
  // Get the stream directly from the repository instance
  final authUserStream = authRepository.authStateChanges();

  // Use switchMap: When authUserStream emits a new value,
  // it switches to the new stream returned by the callback.
  return authUserStream.switchMap((authUser) async* {
    if (authUser == null) {
      yield null; // User is logged out, emit null.
      return; // End this inner stream generator for the null user.
    }

    // Authenticated, get the DB repo and return the user stream
    final db = await ref.watch(quizMockDatabaseRepositoryProvider.future);

    // --- IMPORTANT ---
    // Ideally, your repository should have a method that returns a Stream, e.g., watchUser:
    // yield* db.watchUser(authUser.uid);
    // This ensures real-time updates if the user data changes in the DB.

    // If you only have a Future-based getUser method, wrap it in try-catch:
    try {
      final userModel = await db.getUser(authUser.uid);
      yield userModel;
      // Note: This won't update automatically if DB data changes later, only when auth state changes.
    } catch (e, st) {
      // Log and propagate the error if getUser fails
      _logger.warning(
          'Error fetching user model in currentUserModel for ${authUser.uid}: $e');
      yield* Stream.error(e, st);
    }
  });
}
