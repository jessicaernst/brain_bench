import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/presentation/settings/widgets/cupertino_picker_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _logger = Logger('CupertinoLanguageButton');

class CupertinoLanguageButton extends StatelessWidget {
  const CupertinoLanguageButton({
    super.key,
    required this.currentLocale,
    required this.locales,
    required this.localeNotifier,
    required this.localizations,
    required this.theme,
    required this.textColor,
    required this.isDarkMode,
    required this.getLocalizedName,
  });

  final Locale currentLocale;
  final List<Locale> locales;
  final LocaleNotifier localeNotifier;
  final AppLocalizations localizations;
  final ThemeData theme;
  final Color textColor;
  final bool isDarkMode;
  final String Function(Locale, AppLocalizations) getLocalizedName;

  void _showPicker(BuildContext context) {
    final initialIndex = locales.indexOf(currentLocale);
    if (initialIndex == -1) {
      _logger.warning(
          'Current locale $currentLocale not found in supported locales for picker.');
      return;
    }
    int selectedIndex = initialIndex;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoPickerContent(
        initialIndex: initialIndex,
        locales: locales,
        localeNotifier: localeNotifier,
        localizations: localizations,
        theme: theme,
        textColor: textColor,
        isDarkMode: isDarkMode,
        getLocalizedName: getLocalizedName,
        onIndexChanged: (index) => selectedIndex = index,
        getSelectedIndex: () => selectedIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text(
        supportedLanguages[currentLocale] ?? currentLocale.languageCode,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      onPressed: () => _showPicker(context),
    );
  }
}
