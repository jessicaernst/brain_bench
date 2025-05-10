import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'app_theme_mode';
const String _localeLanguageCodeKey = 'app_locale_language_code';
const String _lastSelectedCategoryIdKey = 'last_selected_category_id';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final SharedPreferences _prefs;

  SharedPreferencesSettingsRepository(this._prefs);

  @override
  Future<ThemeMode> loadThemeMode() async {
    final themeString = _prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
  }

  @override
  Future<Locale> loadLocale() async {
    final languageCode = _prefs.getString(_localeLanguageCodeKey);
    if (languageCode != null) {
      final loadedLocale = supportedLanguages.keys.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => _defaultLocale(),
      );
      return loadedLocale;
    }

    return _defaultLocale();
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeLanguageCodeKey, locale.languageCode);
  }

  Locale _defaultLocale() {
    return supportedLanguages.keys.firstWhere(
      (locale) => locale.languageCode == 'en',
      orElse: () => supportedLanguages.keys.first,
    );
  }

  @override
  Future<void> saveLastSelectedCategoryId(String categoryId) async {
    await _prefs.setString(_lastSelectedCategoryIdKey, categoryId);
  }

  @override
  Future<String?> loadLastSelectedCategoryId() async {
    return _prefs.getString(_lastSelectedCategoryIdKey);
  }

  @override
  Future<void> clearLastSelectedCategoryId() async {
    await _prefs.remove(_lastSelectedCategoryIdKey);
  }
}
