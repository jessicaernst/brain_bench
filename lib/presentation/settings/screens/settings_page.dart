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

    // --- Handle Async ThemeMode for the Switch ---
    final themeModeAsyncValue = ref.watch(themeModeNotifierProvider);

    // Determine the switch state, providing a fallback during loading/error
    // Use maybeWhen for a simpler fallback, or .when for explicit handling
    final bool isSwitchOn = themeModeAsyncValue.maybeWhen(
      data: (currentThemeMode) {
        // Calculate based on loaded data
        switch (currentThemeMode) {
          case ThemeMode.dark:
            return true;
          case ThemeMode.light:
            return false;
          case ThemeMode.system:
            // Use the current theme's brightness if system is selected
            return isDarkMode;
        }
      },
      // Fallback: Use current theme's brightness if loading or error
      orElse: () => isDarkMode,
    );

    // Check if the theme provider is currently loading/saving
    // Note: This checks the provider's overall state, not just saving state
    final bool isThemeBusy = themeModeAsyncValue.isLoading ||
        themeModeAsyncValue.isRefreshing ||
        themeModeAsyncValue.isReloading;

    // Make the handler async because setThemeMode is async
    void handleThemeChange(bool newValue) async {
      // Prevent changing while busy (optional but good practice)
      if (isThemeBusy) return;

      _logger.info('Theme mode toggled via Switch: $newValue');
      // Use await when calling the async method
      await ref.read(themeModeNotifierProvider.notifier).setThemeMode(
            newValue ? ThemeMode.dark : ThemeMode.light,
          );
    }
    // --- End Theme Handling ---

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
                      // --- Theme Row ---
                      Row(
                        children: [
                          Text(
                            localizations.settingsThemeToggleLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          // Optionally show indicator or disable switch when busy
                          if (isThemeBusy)
                            const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                          else
                            LightDarkModeSwitch(
                              value: isSwitchOn,
                              // Pass null to onChanged to disable the switch when busy
                              onChanged: isThemeBusy
                                  ? null
                                  : (value) =>
                                      handleThemeChange(value), // Changed here
                              iconColor: iconColor,
                            ),
                        ],
                      ),
                      // --- End Theme Row ---
                      Divider(
                        height: 0.7,
                        color: dividerColor,
                      ),
                      // --- Language Row ---
                      Row(
                        children: [
                          Text(
                            localizations.settingsLanguageLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          // LanguageSelectionView handles its own AsyncValue internally
                          LanguageSelectionView(),
                        ],
                      ),
                      // --- End Language Row ---
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
