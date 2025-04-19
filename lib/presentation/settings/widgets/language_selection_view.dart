import 'dart:io';

import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionView extends ConsumerWidget {
  const LanguageSelectionView({super.key});

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
    final currentLocale = ref.watch(localeNotifierProvider);
    final localeNotifier = ref.read(localeNotifierProvider.notifier);
    final List<Locale> locales = supportedLanguages.keys.toList();
    final localizations = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.blueprintBlue;

    if (Platform.isIOS || Platform.isMacOS) {
      final initialIndex = locales.indexOf(currentLocale);

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
        onPressed: () {
          int selectedIndex = initialIndex;

          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(
                primaryColor: textColor,
                textTheme: CupertinoTextThemeData(
                  actionTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              child: Container(
                height: 250,
                padding: const EdgeInsets.only(top: 6.0),
                color: isDarkMode
                    ? BrainBenchColors.deepDive
                    : BrainBenchColors.cloudCanvas,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          onPressed: () {
                            localeNotifier.setLocale(locales[selectedIndex]);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialIndex,
                        ),
                        onSelectedItemChanged: (int index) {
                          selectedIndex = index;
                        },
                        children:
                            List<Widget>.generate(locales.length, (index) {
                          return Center(
                            child: Text(
                              _getLocalizedLanguageName(
                                  locales[index], localizations),
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return DropdownButton<Locale>(
        value: currentLocale,
        underline: Container(height: 0),
        onChanged: (Locale? newValue) {
          if (newValue != null) {
            localeNotifier.setLocale(newValue);
          }
        },
        items: locales.map((locale) {
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(
              _getLocalizedLanguageName(locale, localizations),
              style: theme.textTheme.bodyMedium,
            ),
          );
        }).toList(),
      );
    }
  }
}
