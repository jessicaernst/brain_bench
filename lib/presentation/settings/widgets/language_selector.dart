import 'dart:io';
import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/presentation/settings/widgets/cupertino_language_button.dart';
import 'package:brain_bench/presentation/settings/widgets/material_language_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('LanguageSelector');

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.textColor,
    required this.isDarkMode,
  });

  final Locale currentLocale;
  final Color textColor;
  final bool isDarkMode;

  String _getLocalizedLanguageName(
      Locale locale, AppLocalizations localizations) {
    switch (locale.languageCode) {
      case 'en':
        return localizations.languageNameEnglish;
      case 'de':
        return localizations.languageNameGerman;
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeNotifierProvider.notifier);
    final List<Locale> locales = supportedLanguages.keys.toList();
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    _logger.fine('Displaying language selection for locale: $currentLocale');

    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoLanguageButton(
        currentLocale: currentLocale,
        locales: locales,
        localeNotifier: localeNotifier,
        localizations: localizations,
        theme: theme,
        textColor: textColor,
        isDarkMode: isDarkMode,
        getLocalizedName: _getLocalizedLanguageName,
      );
    } else {
      return MaterialLanguageDropdown(
        currentLocale: currentLocale,
        locales: locales,
        localeNotifier: localeNotifier,
        localizations: localizations,
        theme: theme,
        textColor: textColor,
        getLocalizedName: _getLocalizedLanguageName,
      );
    }
  }
}
