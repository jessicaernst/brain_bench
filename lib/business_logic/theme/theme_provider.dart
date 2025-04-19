import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Optional für Persistenz: import 'package:shared_preferences/shared_preferences.dart';
// Optional für Persistenz: import 'package:brain_bench/data/infrastructure/shared_prefs/shared_prefs_provider.dart'; // Beispielpfad

// Generiert die Provider-Definitionen automatisch
part 'theme_provider.g.dart'; // Name der generierten Datei

// Definiert den StateNotifier mit der @riverpod Annotation
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  // Beachte _$
  // Optional: SharedPreferences für Persistenz
  // late final SharedPreferences _prefs;

  // build() wird zur Initialisierung verwendet
  @override
  ThemeMode build() {
    // Optional: SharedPreferences hier initialisieren (wenn benötigt)
    // _prefs = ref.watch(sharedPreferencesProvider); // Annahme: Es gibt einen sharedPrefs Provider

    // Lade den initialen Wert (hier: System)
    return _loadInitialThemeMode();
  }

  // Lädt den initialen Wert
  ThemeMode _loadInitialThemeMode() {
    // Hier könntest du aus _prefs laden:
    // final savedTheme = _prefs.getString('themeMode');
    // if (savedTheme == 'dark') return ThemeMode.dark;
    // if (savedTheme == 'light') return ThemeMode.light;
    return ThemeMode.system; // Standard
  }

  // Methode zum Setzen des ThemeMode
  void setThemeMode(ThemeMode mode) {
    if (state != mode) {
      state = mode;
      // Optional: Speichern
      // _prefs.setString('themeMode', mode.name); // mode.name gibt 'light', 'dark', 'system'
    }
  }

  // Methode zum Umschalten (vereinfacht für den Switch)
  void toggleTheme() {
    // Beachte: Wenn ThemeMode.system aktiv ist, entscheidet diese Logik
    // willkürlich (hier: zu light). Du könntest das anpassen.
    final newMode =
        (state == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(newMode);
  }
}
