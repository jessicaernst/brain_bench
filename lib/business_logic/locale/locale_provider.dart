import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

// Map of supported locales and their display names. Good practice.
final Map<Locale, String> supportedLanguages = {
  const Locale('en'): 'English',
  const Locale('de'): 'Deutsch',
};

final _logger = Logger('LocaleNotifier');

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  late final SettingsRepository _repository;

  @override
  Future<Locale> build() async {
    // Keeps the state alive after the last listener unsubscribes.
    // Suitable for global settings like locale.
    ref.keepAlive();

    _repository = ref.read(settingsRepositoryProvider);
    _logger.info('Loading initial Locale from repository...');
    try {
      final initialLocale = await _repository.loadLocale();
      _logger.info('Initial Locale loaded: $initialLocale');
      return initialLocale;
    } catch (e, stackTrace) {
      // This catch block handles errors during the initial load.
      _logger.severe('Failed to load initial Locale', e, stackTrace);
      // It defines a fallback locale instead of rethrowing the error.
      const fallbackLocale = Locale('en');
      _logger.info(
        'Failed to load initial Locale. Falling back to: $fallbackLocale',
      );
      return fallbackLocale;
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    // Guard clause: Check if state has data, locale is supported, and it's a new locale.
    if (state.hasValue &&
        supportedLanguages.containsKey(newLocale) &&
        state.value != newLocale) {
      _logger.info('Setting Locale from ${state.value} to $newLocale');
      // Optimistic UI update: Set state immediately to the new locale.
      state = AsyncData(newLocale);
      try {
        // Attempt to persist the change via the repository.
        await _repository.saveLocale(newLocale);
        _logger.info('Locale $newLocale saved successfully.');
        // If save succeeds, the state is already correct (AsyncData).
      } catch (e, stackTrace) {
        // If save fails:
        _logger.severe('Failed to save Locale', e, stackTrace);
        // Update state to AsyncError, but keep the optimistically set value
        // using copyWithPrevious for better UX (UI shows error but keeps selection).
        state = AsyncError<Locale>(e, stackTrace).copyWithPrevious(state);
      }
    } else if (!state.hasValue) {
      // Guard clause: Don't allow setting locale if initial load/refresh is in progress or failed without fallback.
      _logger.warning(
        'Cannot set Locale while initial state is loading/error.',
      );
    } else if (!supportedLanguages.containsKey(newLocale)) {
      _logger.warning('Attempted to set unsupported locale: $newLocale');
    } else {
      // Guard clause: Handle setting the same locale again (no action needed).
      _logger.fine('Attempted to set the same locale again: $newLocale');
    }
  }

  /// Refreshes the locale by reloading it from the repository.
  Future<void> refreshLocale() async {
    _logger.info('Attempting to refresh Locale from repository...');
    // Set state to loading, preserving previous data for smoother UI.
    state = const AsyncLoading<Locale>().copyWithPrevious(state);
    try {
      // Reload from repository.
      final refreshedLocale = await _repository.loadLocale();
      _logger.info('Locale refreshed successfully: $refreshedLocale');
      // Update state with refreshed data.
      state = AsyncData(refreshedLocale);
    } catch (e, stackTrace) {
      // If refresh fails:
      _logger.severe('Failed to refresh Locale', e, stackTrace);
      // Update state to error, preserving previous data.
      state = AsyncError<Locale>(e, stackTrace).copyWithPrevious(state);
    }
  }
}
