import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/pickers/cupertino_picker_content.dart';
import 'package:brain_bench/core/shared_widgets/pickers/material_list_picker.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('LanguageSelector');

/// A widget that allows the user to select a language.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    final backgroundColor =
        isDarkMode ? BrainBenchColors.deepDive : BrainBenchColors.cloudCanvas;
    final doneButtonColor =
        isDarkMode
            ? BrainBenchColors.flutterSky
            : BrainBenchColors.blueprintBlue;

    final supportedLocales = supportedLanguages.keys.toList();

    /// Returns the display name for a given [locale].
    String displayName(Locale locale) {
      switch (locale.languageCode) {
        case 'en':
          return localizations.languageNameEnglish;
        case 'de':
          return localizations.languageNameGerman;
        default:
          return locale.languageCode;
      }
    }

    /// Handles the selection of a language.
    void onSelect(Locale selectedLocale) {
      _logger.info('Selected language: $selectedLocale');
      localeNotifier.setLocale(selectedLocale);
      Navigator.pop(context);
    }

    /// Shows the language picker.
    void showPicker() {
      if (P.isIOS || P.isMacOS) {
        showCupertinoModalPopup(
          context: context,
          builder:
              (_) => CupertinoPickerContent<Locale>(
                items: supportedLocales,
                initialSelectedItem: currentLocale,
                itemDisplayNameBuilder: displayName,
                onConfirmed: onSelect,
                localizations: localizations,
                doneButtonColor: doneButtonColor,
                backgroundColor: backgroundColor,
              ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder:
              (_) => MaterialListPicker<Locale>(
                items: supportedLocales,
                selectedItem: currentLocale,
                itemDisplayNameBuilder: displayName,
                onItemSelected: onSelect,
                selectedTileColor: Theme.of(
                  context,
                ).primaryColor.withAlpha((0.1 * 255).toInt()),
                backgroundColor: backgroundColor,
                itemEqualityComparer:
                    (a, b) =>
                        a?.languageCode == b.languageCode &&
                        a?.countryCode == b.countryCode,
              ),
        );
      }
    }

    return InkWell(
      onTap: showPicker,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayName(currentLocale),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.unfold_more, size: 20, color: textColor),
        ],
      ),
    );
  }
}
