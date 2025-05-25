import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/auth/ensure_user_exists_provider.dart';
import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
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

  Future<void> _handleAuthOperation(
    Future<AppUser?> Function() authOperation,
  ) async {
    try {
      final AppUser? appUser = await authOperation();
      if (appUser != null) {
        // Use the provider to get the function
        final ensureUserFunc = ref.read(ensureUserExistsProvider);
        await ensureUserFunc(ref.read, appUser);
        _logger.info('Auth operation successful for user: ${appUser.uid}');
        state = const AsyncData(null); // Reset state on success
      } else {
        // This case should ideally not happen if authOperation is expected to return a user on success
        throw Exception('Auth operation completed but returned no user.');
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
      _logger.severe('Auth operation failed', e, stack);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _handleAuthOperation(
        () => ref.read(authRepositoryProvider).signInWithEmail(email, password),
      );
    } catch (e) {
      /* Error is handled by _handleAuthOperation */
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _handleAuthOperation(
        () => ref.read(authRepositoryProvider).signUpWithEmail(email, password),
      );
    } catch (e) {
      /* Error is handled by _handleAuthOperation */
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    await _handleAuthOperation(
      () => ref.read(authRepositoryProvider).signInWithGoogle(),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    await _handleAuthOperation(
      () => ref.read(authRepositoryProvider).signInWithApple(),
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPasswordResetEmail(email);
      // UI should listen to state changes to show success message
      state = const AsyncData(null); // Indicate success
    } catch (e, st) {
      state = AsyncError(e, st);
      _logger.severe('Password reset email sending failed for $email', e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final settingsRepo = ref.read(settingsRepositoryProvider);

      // 1. Clear local preferences that should not apply to the next user
      await settingsRepo.clearLastSelectedCategoryId();
      _logger.info(
        'Cleared last selected category ID from SharedPreferences on logout.',
      );

      // 2. Firebase sign out
      await repo.signOut();

      // 3. Reset relevant Riverpod states
      // Directly set the state to null for a Notifier
      ref.read(selectedHomeCategoryProvider.notifier).state = null;
      _logger.info('Reset selectedHomeCategoryProvider to null on logout.');

      ref.read(provisionalProfileImageProvider.notifier).clearImage();

      // 4. Invalidate user-specific providers to force a reload
      ref.invalidate(currentUserProvider);
      ref.invalidate(currentUserModelProvider);

      _logger.info(
        'User signed out successfully. Local states and user providers reset/invalidated.',
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      _logger.severe('Sign out failed', e, st);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
