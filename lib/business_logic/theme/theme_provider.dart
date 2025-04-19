import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

final _logger = Logger('ThemeModeNotifier');

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late final SettingsRepository _repository;

  @override
  Future<ThemeMode> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    _logger.info('Loading initial ThemeMode from repository...');
    final initialMode = await _repository.loadThemeMode();
    _logger.info('Initial ThemeMode loaded: $initialMode');
    return initialMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.hasValue && state.value != mode) {
      _logger.info('Setting ThemeMode from ${state.value} to $mode');
      state = AsyncData(mode);
      try {
        await _repository.saveThemeMode(mode);
        _logger.info('ThemeMode $mode saved successfully.');
      } catch (e, stackTrace) {
        _logger.severe('Failed to save ThemeMode', e, stackTrace);
        state = AsyncError(e, stackTrace).copyWithPrevious(state)
            as AsyncValue<ThemeMode>;
      }
    } else if (!state.hasValue) {
      _logger.warning(
          'Cannot set ThemeMode while initial state is loading/error.');
    } else {
      _logger.fine('Attempted to set the same theme mode again: $mode');
    }
  }

  Future<void> toggleTheme() async {
    if (state.hasValue) {
      final currentMode = state.value!;
      final newMode =
          (currentMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
      await setThemeMode(newMode);
    } else {
      _logger
          .warning('Cannot toggle theme while initial state is loading/error.');
    }
  }
}
