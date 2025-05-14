import 'package:brain_bench/business_logic/auth/ensure_user_exists_provider.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart'; // For provisionalProfileImageProvider
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
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
        await ensureUserFunc(ref.read, appUser); // Pass ref.read as the Reader
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
      await repo.signOut();
      // Clear the provisional profile image on logout
      ref.read(provisionalProfileImageProvider.notifier).clearImage();
      _logger.info(
        'User signed out successfully and provisional image cleared.',
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
