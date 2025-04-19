import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

// Definiert die unterstützten Sprachen und ihre Anzeige-Namen
// Wichtig: Die Locale-Codes ('en', 'de') müssen mit deinen .arb-Dateien übereinstimmen
final Map<Locale, String> supportedLanguages = {
  const Locale('en'): 'English',
  const Locale('de'): 'Deutsch',
};

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  // Optional: SharedPreferences für Persistenz
  // late final SharedPreferences _prefs;

  @override
  Locale build() {
    // Optional: SharedPreferences hier initialisieren
    // _prefs = ref.watch(sharedPreferencesProvider);

    // Lade die initial gespeicherte Sprache oder nimm einen Standardwert
    return _loadInitialLocale();
  }

  Locale _loadInitialLocale() {
    // Hier könntest du aus _prefs laden:
    // final savedLanguageCode = _prefs.getString('languageCode');
    // if (savedLanguageCode != null && supportedLanguages.keys.any((locale) => locale.languageCode == savedLanguageCode)) {
    //   return Locale(savedLanguageCode);
    // }

    // Fallback: Nimm die erste unterstützte Sprache oder Englisch
    return supportedLanguages.keys.firstWhere(
      (locale) => locale.languageCode == 'en',
      orElse: () => supportedLanguages.keys.first,
    );
  }

  // Methode zum Setzen der Sprache
  void setLocale(Locale newLocale) {
    // Stelle sicher, dass die neue Locale unterstützt wird
    if (supportedLanguages.containsKey(newLocale) && state != newLocale) {
      state = newLocale;
      // Optional: Speichern
      // _prefs.setString('languageCode', newLocale.languageCode);
    }
  }
}
