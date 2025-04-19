import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

// Define supported languages and their display names (can be moved elsewhere if needed)
// Important: Locale codes ('en', 'de') must match your .arb files
// These display names are primarily for internal mapping; the UI should use localized strings.
final Map<Locale, String> supportedLanguages = {
  const Locale('en'): 'English',
  const Locale('de'): 'Deutsch',
};

// Logger for this notifier
final _logger = Logger('LocaleNotifier');

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  // The repository will be accessed via ref
  late final SettingsRepository _repository;

  // build() becomes async as we need to load the initial value from storage
  @override
  Future<Locale> build() async {
    // Return type is now Future<Locale>
    // Get the repository instance using ref.watch
    // This depends on settingsRepositoryProvider which in turn depends on sharedPreferencesProvider
    // Ensure sharedPreferencesProvider is correctly overridden in main.dart's ProviderScope
    _repository = ref
        .watch(settingsRepositoryProvider); // Use the generated provider name
    _logger.info('Loading initial Locale from repository...');
    // Load the initial locale from the repository
    final initialLocale = await _repository.loadLocale();
    _logger.info('Initial Locale loaded: $initialLocale');
    return initialLocale;
  }

  // Method to set the application's locale
  Future<void> setLocale(Locale newLocale) async {
    // Method becomes async to handle saving
    // Ensure the new locale is supported and different from the current state
    // state.value checks if data has been successfully loaded and is available
    if (state.hasValue &&
        supportedLanguages.containsKey(newLocale) &&
        state.value != newLocale) {
      _logger.info('Setting Locale from ${state.value} to $newLocale');
      // Update the state optimistically with AsyncData before saving
      // This makes the UI react immediately
      state = AsyncData(newLocale);
      try {
        // Save the new locale using the repository
        await _repository.saveLocale(newLocale);
        _logger.info('Locale $newLocale saved successfully.');
      } catch (e, stackTrace) {
        // If saving fails, log the error and update the state to reflect the error
        _logger.severe('Failed to save Locale', e, stackTrace);
        // Update state to AsyncError, keeping the previous data available if needed
        state = AsyncError(e, stackTrace).copyWithPrevious(state)
            as AsyncValue<Locale>;
      }
    } else if (!state.hasValue) {
      // Log a warning if trying to set locale while the initial state is still loading or in error
      _logger
          .warning('Cannot set Locale while initial state is loading/error.');
    } else if (!supportedLanguages.containsKey(newLocale)) {
      // Log a warning if trying to set an unsupported locale
      _logger.warning('Attempted to set unsupported locale: $newLocale');
    } else {
      // Log if trying to set the same locale again (optional, could be fine level)
      _logger.fine('Attempted to set the same locale again: $newLocale');
    }
  }
}
