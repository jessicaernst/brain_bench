import 'package:brain_bench/core/utils/auth/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'user_provider.g.dart';

final Logger _logger = Logger('UserProvider');

/// Stream that provides the current user model based on the authentication state.
/// Retrieves the current user model as a stream of [UserModelState].
/// The [UserModelState] represents the state of the user model, including loading, unauthenticated, error, or data.
/// This function listens to the authentication state changes and fetches the user model from the database.
/// If the user model does not exist, it attempts to create one.
///
/// Parameters:
/// - [ref]: The reference to the current provider.
///
/// Returns:
/// A stream of [UserModelState] representing the state of the user model.
@riverpod
Stream<UserModelState> currentUserModel(Ref ref) {
  final creationInProgress = ref.watch(creationInProgressProvider.notifier);
  final authRepository = ref.watch(authRepositoryProvider);
  final authUserStream = authRepository.authStateChanges();

  return authUserStream.switchMap((authUser) async* {
    if (authUser == null) {
      _logger.info('currentUserModel: No auth user.');
      yield const UserModelState.unauthenticated();
      return;
    }

    final userRepo = await ref.watch(userRepositoryProvider.future);

    try {
      yield const UserModelState.loading();

      model.AppUser? userModel = await userRepo.getUser(authUser.uid);

      if (userModel == null) {
        if (creationInProgress.contains(authUser.uid)) {
          yield const UserModelState.loading();
          return;
        }

        creationInProgress.start(authUser.uid);

        try {
          await ensureUserExistsIfNeeded(ref.read, authUser);
          userModel = await userRepo.getUser(authUser.uid);
        } catch (error, stack) {
          _logger.severe('Error creating user ', error, stack);
          yield UserModelState.error(
            uid: authUser.uid,
            message: error.toString(),
          );
          return;
        } finally {
          creationInProgress.finish(authUser.uid);
        }
      }

      if (userModel == null) {
        final error = StateError('User could not be found or created.');
        _logger.severe('currentUserModel: ${error.message}');
        yield UserModelState.error(uid: authUser.uid, message: error.message);
      } else {
        yield UserModelState.data(userModel);
      }
    } catch (e, st) {
      _logger.severe(
        'Caught unexpected error in currentUserModel stream processing',
        e,
        st,
      );
      yield UserModelState.error(uid: authUser.uid, message: e.toString());
    }
  });
}

/// Notifier for tracking the creation progress of user objects.
class CreationInProgressNotifier extends StateNotifier<Set<String>> {
  CreationInProgressNotifier() : super({});

  /// Checks if the given [uid] is in the set of creation in progress.
  bool contains(String uid) => state.contains(uid);

  /// Starts the creation progress for the given [uid].
  void start(String uid) {
    if (!state.contains(uid)) {
      state = {...state, uid};
    }
  }

  /// Finishes the creation progress for the given [uid].
  void finish(String uid) {
    final newState = {...state}..remove(uid);
    state = newState;
  }
}

/// Provider for the [CreationInProgressNotifier] that holds the set of UIDs in creation progress.
final creationInProgressProvider =
    StateNotifierProvider<CreationInProgressNotifier, Set<String>>(
      (ref) => CreationInProgressNotifier(),
    );
