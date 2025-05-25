import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

final Map<Locale, String> supportedLanguages = {
  const Locale('en'): 'English',
  const Locale('de'): 'Deutsch',
};

final _logger = Logger('LocaleNotifier');

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  // Access SharedPreferences via a getter to ensure it's read once per provider instance
  // and to avoid LateInitializationError if build is called multiple times.
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Future<Locale> build() async {
    ref.keepAlive();
    _logger.info('LocaleNotifier: build initiated.');

    // Watch for changes in the current user's authentication state and data.
    final AsyncValue<AppUser?> authUserAsyncValue = ref.watch(
      currentUserProvider,
    );

    return authUserAsyncValue.when(
      data: (AppUser? currentUser) async {
        if (currentUser != null) {
          // User is logged in, prioritize their locale setting from Firestore.
          _logger.fine(
            'LocaleNotifier: User available. Loading locale from AppUser: ${currentUser.language}',
          );
          final String langCodeFromUser = currentUser.language;
          _logger.info(
            'LocaleNotifier: Initial Locale determined from AppUser: $langCodeFromUser',
          );
          return Locale(langCodeFromUser);
        } else {
          // No authenticated user, fall back to SharedPreferences.
          _logger.fine(
            'LocaleNotifier: No authenticated user. Falling back to SharedPreferences.',
          );
          return _loadLocaleFromPrefsWithFallback();
        }
      },
      loading: () async {
        // User state is loading, fall back to SharedPreferences for now.
        _logger.fine(
          'LocaleNotifier: currentUserProvider is loading. Falling back to SharedPreferences.',
        );
        return _loadLocaleFromPrefsWithFallback();
      },
      error: (err, stack) async {
        // Error fetching user, fall back to SharedPreferences.
        _logger.severe(
          'LocaleNotifier: Error in currentUserProvider. Falling back to SharedPreferences.',
          err,
          stack,
        );
        return _loadLocaleFromPrefsWithFallback();
      },
    );
  }

  // Helper method to load from SharedPreferences or return default
  Future<Locale> _loadLocaleFromPrefsWithFallback() async {
    try {
      final languageCode = _prefs.getString('app_locale_language_code');
      if (languageCode != null) {
        final loadedLocale = supportedLanguages.keys.firstWhere(
          (locale) => locale.languageCode == languageCode,
          orElse: () => _defaultLocale(), // Use the helper method
        );
        _logger.info(
          'LocaleNotifier: Locale loaded from SharedPreferences: $loadedLocale',
        );
        return loadedLocale;
      }
    } catch (e, stackTrace) {
      _logger.severe(
        'LocaleNotifier: Error loading locale from SharedPreferences',
        e,
        stackTrace,
      );
    }
    final fallbackLocale = _defaultLocale();
    _logger.info(
      'LocaleNotifier: No SharedPreferences data for locale. Falling back to default: $fallbackLocale',
    );
    return fallbackLocale;
  }

  Future<void> setLocale(Locale newLocale) async {
    // Guard clause: Check if state has data, locale is supported, and it's a new locale.
    if (state.hasValue &&
        supportedLanguages.containsKey(newLocale) &&
        state.value != newLocale) {
      _logger.info('Setting Locale from ${state.value} to $newLocale');
      // Optimistic UI update: Set state immediately to the new locale.
      state = AsyncData(newLocale);
      final String langCode = newLocale.languageCode;

      try {
        // 1. Save locally to SharedPreferences immediately
        await _prefs.setString('app_locale_language_code', langCode);
        _logger.info('Locale $newLocale saved to SharedPreferences.');

        // 2. Attempt to save to Firestore if user is logged in
        final AppUser? currentUser = ref.read(currentUserProvider).valueOrNull;
        if (currentUser != null) {
          _logger.fine(
            'User found. Attempting to save locale to Firestore for user ${currentUser.uid}.',
          );
          // Correctly await the repository instance if it's an async provider
          final userRepository = ref.read(userFirebaseRepositoryProvider);
          await userRepository.updateUserProfile(
            userId: currentUser.uid,
            language: langCode,
          );
          // Invalidate currentUserProvider to refresh AppUser data app-wide
          ref.invalidate(
            currentUserProvider,
          ); // Or your currentUserModelProvider
          _logger.info(
            'Locale $langCode saved to Firestore for user ${currentUser.uid}.',
          );
        } else {
          _logger.fine('No user logged in. Locale saved locally only.');
        }
        // State is already AsyncData(newLocale), no need to assign again on success.
      } catch (e, stackTrace) {
        // If save fails:
        _logger.severe(
          'Failed to save Locale $newLocale (langCode: $langCode)',
          e,
          stackTrace,
        );
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
      // The logic here mirrors the build() method for loading.
      final AppUser? currentUser = ref.read(currentUserProvider).valueOrNull;
      Locale refreshedLocale;

      if (currentUser != null) {
        _logger.fine(
          'User found during refresh. Loading locale from AppUser: ${currentUser.language}',
        );
        final String langCodeFromUser = currentUser.language;
        // Do NOT write to SharedPreferences here during a refresh load from AppUser.
        refreshedLocale = Locale(langCodeFromUser);
      } else {
        _logger.fine(
          'No user during refresh. Loading locale from SharedPreferences.',
        );
        final languageCode = _prefs.getString('app_locale_language_code');
        if (languageCode != null) {
          refreshedLocale = supportedLanguages.keys.firstWhere(
            (locale) => locale.languageCode == languageCode,
            orElse: () => _defaultLocale(),
          );
        } else {
          refreshedLocale = _defaultLocale();
        }
      }
      _logger.info('Locale refreshed successfully: $refreshedLocale');
      // Update state with refreshed data.
      state = AsyncData(refreshedLocale);
    } catch (e, stackTrace) {
      // If refresh fails:
      _logger.severe('Failed to refresh Locale', e, stackTrace);
      state = AsyncError<Locale>(e, stackTrace).copyWithPrevious(state);
    }
  }

  // Helper method to get the default locale (extracted for reusability)
  Locale _defaultLocale() {
    return supportedLanguages.keys.firstWhere(
      (locale) => locale.languageCode == 'en', // Prefer 'en'
      orElse:
          () =>
              supportedLanguages
                  .keys
                  .first, // Fallback to the first supported language
    );
  }
}
