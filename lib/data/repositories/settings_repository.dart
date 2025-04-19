import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<ThemeMode> loadThemeMode();
  Future<void> saveLocale(Locale locale);
  Future<Locale> loadLocale();
}
