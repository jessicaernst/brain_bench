import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

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
    _repository = ref.watch(settingsRepositoryProvider);
    _logger.info('Loading initial Locale from repository...');
    final initialLocale = await _repository.loadLocale();
    _logger.info('Initial Locale loaded: $initialLocale');
    return initialLocale;
  }

  Future<void> setLocale(Locale newLocale) async {
    if (state.hasValue &&
        supportedLanguages.containsKey(newLocale) &&
        state.value != newLocale) {
      _logger.info('Setting Locale from ${state.value} to $newLocale');
      state = AsyncData(newLocale);
      try {
        await _repository.saveLocale(newLocale);
        _logger.info('Locale $newLocale saved successfully.');
      } catch (e, stackTrace) {
        _logger.severe('Failed to save Locale', e, stackTrace);
        state = AsyncError(e, stackTrace).copyWithPrevious(state)
            as AsyncValue<Locale>;
      }
    } else if (!state.hasValue) {
      _logger
          .warning('Cannot set Locale while initial state is loading/error.');
    } else if (!supportedLanguages.containsKey(newLocale)) {
      _logger.warning('Attempted to set unsupported locale: $newLocale');
    } else {
      _logger.fine('Attempted to set the same locale again: $newLocale');
    }
  }
}
