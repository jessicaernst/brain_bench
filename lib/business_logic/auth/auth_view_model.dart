import 'package:brain_bench/core/utils/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

final Logger _logger = Logger('AuthViewModel');

/// ViewModel class for handling authentication logic.
/// This class extends the generated `_$AuthViewModel` class from the Riverpod package.
/// It provides methods for signing in, signing up, signing in with Google and Apple,
/// sending password reset emails, signing out, and resetting the state.
/// It also includes private helper methods for error handling and displaying error messages.
@Riverpod(keepAlive: false)
class AuthViewModel extends _$AuthViewModel {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final appUser = await repo.signInWithEmail(email, password);
      _logger.info('AuthViewModel received from repo after Email Sign-In: '
          'UID=${appUser.uid}, Name=${appUser.displayName}, Photo=${appUser.photoUrl}');

      // If ensureUserExistsIfNeeded now re-throws, this await might throw
      final bool newUserCreated =
          await ensureUserExistsIfNeeded(ref.read, appUser);

      if (newUserCreated) {
        _logger.info(
            'New user was created, invalidating currentUserModelProvider.');
        ref.invalidate(currentUserModelProvider);
        // await Future.delayed(const Duration(milliseconds: 100)); // Removed delay
      }
      state = const AsyncData(null);
    } catch (e, st) {
      // This block will now catch errors from ensureUserExistsIfNeeded too
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final appUser = await repo.signUpWithEmail(email, password);
      _logger.info('AuthViewModel received from repo after Email Sign-Up: '
          'UID=${appUser.uid}, Name=${appUser.displayName}, Photo=${appUser.photoUrl}');

      // If ensureUserExistsIfNeeded now re-throws, this await might throw
      final bool newUserCreated =
          await ensureUserExistsIfNeeded(ref.read, appUser);

      if (newUserCreated) {
        _logger.info(
            'New user was created, invalidating currentUserModelProvider.');
        ref.invalidate(currentUserModelProvider);
        // await Future.delayed(const Duration(milliseconds: 100)); // Removed delay
      }
      state = const AsyncData(null);
    } catch (e, st) {
      // This block will now catch errors from ensureUserExistsIfNeeded too
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final appUser = await repo.signInWithGoogle();
      _logger.info('AuthViewModel received from repo after Google Sign-In: '
          'UID=${appUser.uid}, Name=${appUser.displayName}, Photo=${appUser.photoUrl}');

      final bool newUserCreated =
          await ensureUserExistsIfNeeded(ref.read, appUser);

      if (newUserCreated) {
        _logger.info(
            'New user was created, invalidating currentUserModelProvider.');
        ref.invalidate(currentUserModelProvider);
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final appUser = await repo.signInWithApple();
      _logger.info('AuthViewModel received from repo after Apple Sign-In: '
          'UID=${appUser.uid}, Name=${appUser.displayName}, Photo=${appUser.photoUrl}, Email=${appUser.email}');

      final bool newUserCreated =
          await ensureUserExistsIfNeeded(ref.read, appUser);

      if (newUserCreated) {
        _logger.info(
            'New user was created, invalidating currentUserModelProvider.');
        ref.invalidate(currentUserModelProvider);
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPasswordResetEmail(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent.')),
        );
        reset();
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> signOut(BuildContext context) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }

  void _showError(BuildContext context, Object error) {
    final message = error.toString();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message')),
      );
    }
  }
}
