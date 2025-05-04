import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart'; // Import AuthRepository provider
import 'package:brain_bench/data/infrastructure/database_providers.dart'; // Keep DB provider import
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'user_provider.g.dart';

final Logger _logger = Logger('UserProvider');

/// Returns a stream of the current authenticated user model.
///
/// This function retrieves the current authenticated user from the [authRepository]
/// and then fetches the corresponding user model from the [db]. It returns a stream
/// of [model.AppUser] objects representing the current user.
///
/// If the [authUser] is null, it yields null. Otherwise, it fetches the user model
/// from the [db] using the [authUser.uid] and yields the user model.
///
/// If an error occurs during the process, it logs a warning message and yields
/// the error using a stream error.
@riverpod
Stream<model.AppUser?> currentUserModel(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  final authUserStream = authRepository.authStateChanges();

  return authUserStream.switchMap((authUser) async* {
    if (authUser == null) {
      yield null;
      return;
    }

    final db = await ref.watch(quizMockDatabaseRepositoryProvider.future);

    try {
      final userModel = await db.getUser(authUser.uid);
      yield userModel;
    } catch (e, st) {
      _logger.warning(
          'Error fetching user model in currentUserModel for ${authUser.uid}: $e');
      yield* Stream.error(e, st);
    }
  });
}
