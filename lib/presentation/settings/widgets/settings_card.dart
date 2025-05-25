import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/cards/glass_card_view.dart';
import 'package:brain_bench/presentation/settings/widgets/error_content_view.dart';
import 'package:brain_bench/presentation/settings/widgets/language_selection_view.dart';
import 'package:brain_bench/presentation/settings/widgets/light_dark_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SettingsCard');

/// Represents a card widget for displaying settings in the app.
/// This widget includes options for toggling themes and selecting languages.
/// It handles different states such as loading, error, and normal display.
class SettingsCard extends ConsumerWidget {
  const SettingsCard({
    super.key,
    required this.localizations,
    required this.hasThemeSaveError,
    required this.theme,
    required this.isThemeBusy,
    required this.isSwitchOn,
    required this.iconColor,
    required this.dividerColor,
    required this.hasLocaleSaveError,
    required this.isLocaleBusy,
  });

  final AppLocalizations localizations;
  final bool hasThemeSaveError;
  final ThemeData theme;
  final bool isThemeBusy;
  final bool isSwitchOn;
  final Color iconColor;
  final Color dividerColor;
  final bool hasLocaleSaveError;
  final bool isLocaleBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Theme Change Handler ---
    void handleThemeChange(bool newValue) async {
      if (isThemeBusy || hasThemeSaveError) {
        return;
      }
      _logger.info('Theme mode toggled via Switch: $newValue');
      await ref
          .read(themeModeNotifierProvider.notifier)
          .setThemeMode(newValue ? ThemeMode.dark : ThemeMode.light);
    }

    // --- Theme Refresh Handler (for error recovery) ---
    void handleThemeRefresh() async {
      if (isThemeBusy) return;
      _logger.info('Attempting to refresh theme due to previous error...');
      await ref.read(themeModeNotifierProvider.notifier).refreshTheme();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.settingsThemeRefreshed)),
        );
      }
    }

    // --- Locale Refresh Handler (for error recovery) ---
    void handleLocaleRefresh() async {
      if (isLocaleBusy) return;
      _logger.info('Attempting to refresh locale due to previous error...');
      await ref.read(localeNotifierProvider.notifier).refreshLocale();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.settingsLocaleRefreshed)),
        );
      }
    }

    return GlassCardView(
      content: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                localizations.settingsThemeToggleLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              if (hasThemeSaveError)
                ErrorContentView(
                  theme: theme,
                  isBusy: isThemeBusy,
                  localizations: localizations,
                  handleRefresh: handleThemeRefresh,
                )
              else if (isThemeBusy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                LightDarkModeSwitch(
                  value: isSwitchOn,
                  onChanged: isThemeBusy ? null : handleThemeChange,
                  iconColor: iconColor,
                ),
            ],
          ),
          Divider(height: 0.7, color: dividerColor),
          // --- Language Row ---
          Row(
            children: [
              Text(
                localizations.settingsLanguageLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              if (hasLocaleSaveError)
                ErrorContentView(
                  theme: theme,
                  isBusy: isLocaleBusy,
                  localizations: localizations,
                  handleRefresh: handleLocaleRefresh,
                )
              else if (isLocaleBusy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                LanguageSelectionView(),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
