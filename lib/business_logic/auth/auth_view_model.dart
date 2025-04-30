import 'package:brain_bench/core/utils/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

final Logger _logger = Logger('AuthViewModel');

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
      await ensureUserExistsIfNeeded(ref.read, appUser);

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
      await ensureUserExistsIfNeeded(ref.read, appUser);

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

      // If ensureUserExistsIfNeeded now re-throws, this await might throw
      await ensureUserExistsIfNeeded(ref.read, appUser);

      state = const AsyncData(null);
    } catch (e, st) {
      // This block will now catch errors from ensureUserExistsIfNeeded too
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

      // If ensureUserExistsIfNeeded now re-throws, this await might throw
      await ensureUserExistsIfNeeded(ref.read, appUser);

      state = const AsyncData(null);
    } catch (e, st) {
      // This block will now catch errors from ensureUserExistsIfNeeded too
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
