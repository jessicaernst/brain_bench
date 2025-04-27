import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class MaterialLanguageDropdown extends StatelessWidget {
  const MaterialLanguageDropdown({
    super.key,
    required this.currentLocale,
    required this.locales,
    required this.localeNotifier,
    required this.localizations,
    required this.theme,
    required this.textColor,
    required this.getLocalizedName,
  });

  final Locale currentLocale;
  final List<Locale> locales;
  final LocaleNotifier localeNotifier;
  final AppLocalizations localizations;
  final ThemeData theme;
  final Color textColor;
  final String Function(Locale, AppLocalizations) getLocalizedName;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: currentLocale,
      underline: Container(height: 0),
      style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      iconEnabledColor: textColor,
      onChanged: (Locale? newValue) {
        if (newValue != null) {
          localeNotifier.setLocale(newValue);
        }
      },
      items: locales.map((locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(
            getLocalizedName(locale, localizations),
            style: theme.textTheme.bodyMedium,
          ),
        );
      }).toList(),
    );
  }
}
