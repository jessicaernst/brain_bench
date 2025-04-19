import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/component_widgets/profile_settings_page_background.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/settings/widgets/language_selection_view.dart';
import 'package:brain_bench/presentation/settings/widgets/light_dark_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SettingsPage');

class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());
    final Color dividerColor = isDarkMode
        ? BrainBenchColors.cloudCanvas.withAlpha((0.5 * 255).toInt())
        : BrainBenchColors.deepDive.withAlpha((0.5 * 255).toInt());

    final currentThemeMode = ref.watch(themeModeNotifierProvider);

    final bool isSwitchOn;
    switch (currentThemeMode) {
      case ThemeMode.dark:
        isSwitchOn = true;
        break;
      case ThemeMode.light:
        isSwitchOn = false;
        break;
      case ThemeMode.system:
        isSwitchOn = isDarkMode;
        break;
    }

    void handleThemeChange(bool newValue) {
      _logger.info('Theme mode toggled via Switch: $newValue');
      ref.read(themeModeNotifierProvider.notifier).setThemeMode(
            newValue ? ThemeMode.dark : ThemeMode.light,
          );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CloseNavAppBar(
        title: localizations.settingsAppBarTitle,
        onBack: () => context.pop(),
        leadingIconColor: iconColor,
      ),
      body: Stack(
        children: [
          const ProfileSettingsPageBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GlassCardView(
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
                          LightDarkModeSwitch(
                            value: isSwitchOn,
                            onChanged: handleThemeChange,
                            iconColor: iconColor,
                          ),
                        ],
                      ),
                      Divider(
                        height: 0.7,
                        color: dividerColor,
                      ),
                      Row(
                        children: [
                          Text(
                            localizations.settingsLanguageLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          const LanguageSelectionView(),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
