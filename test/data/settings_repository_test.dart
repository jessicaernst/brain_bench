import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late ProviderContainer container;
  late SettingsRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ]);

    repository = container.read(settingsRepositoryProvider);
  });

  group('settingsRepositoryProvider', () {
    test('returns a SettingsRepository instance', () {
      expect(repository, isA<SettingsRepository>());
    });

    test('stores and retrieves theme mode', () async {
      await repository.saveThemeMode(ThemeMode.dark);
      final theme = await repository.loadThemeMode();
      expect(theme, ThemeMode.dark);
    });

    test('stores and retrieves locale', () async {
      const testLocale = Locale('de');
      await repository.saveLocale(testLocale);
      final locale = await repository.loadLocale();
      expect(locale.languageCode, 'de');
    });
  });
}
