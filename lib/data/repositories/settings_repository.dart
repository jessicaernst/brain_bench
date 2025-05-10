import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<ThemeMode> loadThemeMode();
  Future<void> saveLocale(Locale locale);
  Future<Locale> loadLocale();
  Future<void> saveLastSelectedCategoryId(String categoryId);
  Future<String?> loadLastSelectedCategoryId();
  Future<void> clearLastSelectedCategoryId();
}
