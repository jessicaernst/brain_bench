import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
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
      await repo.signInWithEmail(email, password);
      _logger.info('Email Sign-In attempt successful via repository.');

      state = const AsyncData(null);
    } catch (e, st) {
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
      await repo.signUpWithEmail(email, password);
      _logger.info('Email Sign-Up attempt successful via repository.');

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithGoogle();
      _logger.info('Google Sign-In attempt successful via repository.');

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
      await repo.signInWithApple();
      _logger.info('Apple Sign-In attempt successful via repository.');

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $message')));
    }
  }
}
