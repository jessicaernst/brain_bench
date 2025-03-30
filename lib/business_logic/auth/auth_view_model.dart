import 'package:brain_bench/data/providers/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
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
      if (context.mounted) {
        context.go('/home');
      }
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
      if (context.mounted) {
        context.go('/home');
      }
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
      if (context.mounted) context.go('/home');
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
      if (context.mounted) context.go('/home');
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
      if (context.mounted) {
        context.go('/login');
      }
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
