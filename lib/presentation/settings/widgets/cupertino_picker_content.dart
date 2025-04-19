import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoPickerContent extends StatelessWidget {
  const CupertinoPickerContent({
    super.key,
    required this.initialIndex,
    required this.locales,
    required this.localeNotifier,
    required this.localizations,
    required this.theme,
    required this.textColor,
    required this.isDarkMode,
    required this.getLocalizedName,
    required this.onIndexChanged,
    required this.getSelectedIndex,
  });

  final int initialIndex;
  final List<Locale> locales;
  final LocaleNotifier localeNotifier;
  final AppLocalizations localizations;
  final ThemeData theme;
  final Color textColor;
  final bool isDarkMode;
  final String Function(Locale, AppLocalizations) getLocalizedName;
  final ValueChanged<int> onIndexChanged;
  final int Function() getSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
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
                    localeNotifier.setLocale(locales[getSelectedIndex()]);
                    Navigator.pop(context);
                  },
                  child: Text(
                    localizations.pickerDoneButton,
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
                onSelectedItemChanged: onIndexChanged,
                children: List<Widget>.generate(locales.length, (index) {
                  return Center(
                    child: Text(
                      getLocalizedName(locales[index], localizations),
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
