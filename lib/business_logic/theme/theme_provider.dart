import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart'; // Assuming this is needed indirectly by repository
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

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
  late final SettingsRepository _repository;

  @override
  Future<ThemeMode> build() async {
    // Keeps the state alive after the last listener unsubscribes.
    // Suitable for global settings like locale.
    ref.keepAlive();

    // Use ref.watch here if you want the provider to rebuild if the
    // repository provider itself changes (less common). Use ref.read
    // if you only need the instance once during initialization.
    // Given it's unlikely the repository provider changes, read is fine.
    _repository = ref.read(settingsRepositoryProvider);
    _logger.info('Loading initial ThemeMode from repository...');
    try {
      final initialMode = await _repository.loadThemeMode();
      _logger.info('Initial ThemeMode loaded: $initialMode');
      return initialMode;
    } catch (e, stackTrace) {
      _logger.severe('Failed to load initial ThemeMode', e, stackTrace);
      // Propagate the error to the initial state
      rethrow;
    }
  }

  // Removed the private _getNextThemeMode method

  /// Attempts to save the theme mode to the repository and updates the state
  /// to reflect success or failure (with error propagation).
  Future<void> _persistThemeMode(ThemeMode mode) async {
    try {
      await _repository.saveThemeMode(mode);
      _logger.info('ThemeMode $mode saved successfully.');
      // On success, the state is already optimistically set, so no change needed here.
    } catch (e, stackTrace) {
      _logger.severe('Failed to save ThemeMode $mode', e, stackTrace);
      // Update state to error, preserving the optimistic value set before calling this.
      final newState =
          AsyncError<ThemeMode>(e, stackTrace).copyWithPrevious(state);
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
      // Attempt to persist the change and handle potential errors
      await _persistThemeMode(mode);
    }
    // Guard Clause 2: Handle case where state is not ready (loading/initial error)
    else if (!state.hasValue) {
      _logger.warning(
          'Cannot set ThemeMode while initial state is loading/error.');
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
      _logger
          .warning('Cannot toggle theme while initial state is loading/error.');
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
      final refreshedMode = await _repository.loadThemeMode();
      _logger.info('ThemeMode refreshed successfully: $refreshedMode');
      state = AsyncData(refreshedMode);
    } catch (e, stackTrace) {
      _logger.severe('Failed to refresh ThemeMode', e, stackTrace);
      // Set state to error, keeping previous data
      state = AsyncError<ThemeMode>(e, stackTrace).copyWithPrevious(state);
    }
  }
}
