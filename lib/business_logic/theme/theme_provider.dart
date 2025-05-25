import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const String _themeModeKey = 'app_theme_mode';

final _logger = Logger('ThemeModeNotifier');

/// Calculates the next theme mode in the cycle: System -> Light -> Dark -> System.
///
/// This is a pure function, making it easily testable.
ThemeMode getNextThemeModeCycle(ThemeMode currentMode) {
  switch (currentMode) {
    case ThemeMode.system:
      return ThemeMode.light;
    case ThemeMode.light:
      return ThemeMode.dark;
    case ThemeMode.dark:
      return ThemeMode.system;
  }
}

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  // Access SharedPreferences via a getter to ensure it's read once per provider instance
  // and to avoid LateInitializationError if build is called multiple times.
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Future<ThemeMode> build() async {
    ref.keepAlive();
    _logger.info('ThemeModeNotifier: build initiated.');

    // Watch for changes in the current user's authentication state and data.
    final AsyncValue<AppUser?> authUserAsyncValue = ref.watch(
      currentUserProvider,
    );

    return authUserAsyncValue.when(
      data: (AppUser? currentUser) async {
        if (currentUser != null) {
          // User is logged in, prioritize their theme setting from Firestore.
          // Do NOT write to SharedPreferences here; only read from AppUser.
          _logger.fine(
            'ThemeModeNotifier.build: User available. AppUser.themeMode: ${currentUser.themeMode}, current provider state.value: ${state.valueOrNull}',
          );
          final String themeModeStringFromUser = currentUser.themeMode;
          _logger.info(
            'ThemeModeNotifier: Initial ThemeMode determined from AppUser: $themeModeStringFromUser',
          );
          return _stringToThemeMode(themeModeStringFromUser);
        } else {
          // No authenticated user, fall back to SharedPreferences.
          _logger.fine(
            'ThemeModeNotifier: No authenticated user. Falling back to SharedPreferences.',
          );
          return _loadThemeModeFromPrefsWithFallback();
        }
      },
      loading: () async {
        // User state is loading, fall back to SharedPreferences for now.
        _logger.fine(
          'ThemeModeNotifier: currentUserProvider is loading. Falling back to SharedPreferences.',
        );
        return _loadThemeModeFromPrefsWithFallback();
      },
      error: (err, stack) async {
        // Error fetching user, fall back to SharedPreferences.
        _logger.severe(
          'ThemeModeNotifier: Error in currentUserProvider. Falling back to SharedPreferences.',
          err,
          stack,
        );
        return _loadThemeModeFromPrefsWithFallback();
      },
    );
  }

  Future<ThemeMode> _loadThemeModeFromPrefsWithFallback() async {
    try {
      final themeString = _prefs.getString(_themeModeKey);
      if (themeString != null) {
        final loadedMode = _stringToThemeMode(themeString);
        _logger.info(
          'ThemeModeNotifier: ThemeMode loaded from SharedPreferences: $loadedMode',
        );
        return loadedMode;
      }
    } catch (e, stackTrace) {
      _logger.severe(
        'ThemeModeNotifier: Error loading themeMode from SharedPreferences',
        e,
        stackTrace,
      );
    }
    const fallbackMode = ThemeMode.system;
    _logger.info(
      'ThemeModeNotifier: No SharedPreferences data for theme. Falling back to default: $fallbackMode',
    );
    return fallbackMode;
  }

  /// Attempts to save the theme mode to the repository and updates the state
  /// to reflect success or failure (with error propagation).
  Future<void> _persistThemeMode(ThemeMode mode, String themeModeString) async {
    try {
      // 1. Save locally to SharedPreferences immediately
      await _prefs.setString(_themeModeKey, themeModeString);
      _logger.info('ThemeMode $mode saved to SharedPreferences.');
    } catch (e, stackTrace) {
      _logger.severe('Failed to save ThemeMode $mode', e, stackTrace);
      // Update state to error, preserving the optimistic value set before calling this.
      final newState = AsyncError<ThemeMode>(
        e,
        stackTrace,
      ).copyWithPrevious(state);
      state = newState;
    }
  }

  /// Sets the application's theme mode.
  ///
  /// Updates the state optimistically and then attempts to persist the change.
  /// If persistence fails, the state is updated to reflect the error while
  /// keeping the optimistically set value.
  Future<void> setThemeMode(ThemeMode mode) async {
    // Guard Clause 1: Check if update is necessary and possible
    if (state.hasValue && state.value != mode) {
      _logger.info('Setting ThemeMode from ${state.value} to $mode');
      // Optimistic UI update: Change the state immediately
      state = AsyncData(mode);
      final String themeModeString = _themeModeToString(mode);

      try {
        // Persist locally
        await _persistThemeMode(mode, themeModeString);

        // Attempt to save to Firestore if user is logged in
        final AppUser? currentUser = ref.read(currentUserProvider).valueOrNull;
        if (currentUser != null) {
          _logger.fine(
            'User found. Attempting to save themeMode to Firestore for user ${currentUser.uid}.',
          );
          _logger.info(
            'Attempting to save themeMode: $themeModeString to Firestore for user ${currentUser.uid}',
          );
          // Correctly await the repository instance if it's an async provider
          final userRepository = ref.read(userFirebaseRepositoryProvider);
          await userRepository.updateUserProfile(
            userId: currentUser.uid,
            themeMode: themeModeString,
          );
          _logger.info(
            'Firestore update call completed for themeMode: $themeModeString, user: ${currentUser.uid}. Invalidating currentUserProvider.',
          );
          ref.invalidate(currentUserProvider);
          _logger.info(
            'ThemeMode $themeModeString saved to Firestore for user ${currentUser.uid}.',
          );
        } else {
          _logger.fine('No user logged in. ThemeMode saved locally only.');
        }
      } catch (e, stackTrace) {
        _logger.severe('Failed to fully save ThemeMode $mode', e, stackTrace);
        state = AsyncError<ThemeMode>(e, stackTrace).copyWithPrevious(state);
      }
    }
    // Guard Clause 2: Handle case where state is not ready (loading/initial error)
    else if (!state.hasValue) {
      _logger.warning(
        'Cannot set ThemeMode while initial state is loading/error.',
      );
    }
    // Guard Clause 3: Handle redundant calls (setting the same mode again)
    else {
      // This implies state.hasValue && state.value == mode
      _logger.fine('Attempted to set the same theme mode again: $mode');
    }
  }

  /// Toggles the theme mode by cycling through System -> Light -> Dark -> System.
  Future<void> toggleTheme() async {
    final currentMode = state.valueOrNull;
    if (currentMode != null) {
      // Use the extracted pure function
      final newMode = getNextThemeModeCycle(currentMode);
      // Use the main setter function which handles state updates and persistence
      await setThemeMode(newMode);
    } else {
      _logger.warning(
        'Cannot toggle theme while initial state is loading/error.',
      );
    }
  }

  /// Refreshes the theme mode by reloading it from the repository.
  ///
  /// This can be useful if the underlying storage might have changed externally
  /// or to recover from a previous save error state.
  Future<void> refreshTheme() async {
    _logger.info('Attempting to refresh ThemeMode from repository...');
    // Set state to loading, but keep previous data if available for smoother UI
    state = const AsyncLoading<ThemeMode>().copyWithPrevious(state);
    try {
      // The logic here mirrors the build() method for loading.
      final AppUser? currentUser = ref.read(currentUserProvider).valueOrNull;
      ThemeMode refreshedMode;

      if (currentUser != null) {
        _logger.fine(
          'User found during refresh. Loading themeMode from AppUser: ${currentUser.themeMode}',
        );
        final String themeModeStringFromUser = currentUser.themeMode;
        // Do NOT write to SharedPreferences here during a refresh load from AppUser.
        refreshedMode = _stringToThemeMode(themeModeStringFromUser);
      } else {
        _logger.fine(
          'No user during refresh. Loading themeMode from SharedPreferences.',
        );
        final themeString = _prefs.getString(_themeModeKey);
        if (themeString != null) {
          refreshedMode = _stringToThemeMode(themeString);
        } else {
          refreshedMode = ThemeMode.system; // Fallback
        }
      }
      _logger.info('ThemeMode refreshed successfully: $refreshedMode');
      state = AsyncData(refreshedMode);
    } catch (e, stackTrace) {
      _logger.severe('Failed to refresh ThemeMode', e, stackTrace);
      // Set state to error, keeping previous data
      state = AsyncError<ThemeMode>(e, stackTrace).copyWithPrevious(state);
    }
  }

  // Helper methods for conversion
  ThemeMode _stringToThemeMode(String themeString) => ThemeMode.values
      .firstWhere((e) => e.name == themeString, orElse: () => ThemeMode.system);

  String _themeModeToString(ThemeMode themeMode) => themeMode.name;
}
