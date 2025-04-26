import 'package:brain_bench/business_logic/locale/locale_provider.dart'; // Import locale provider
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/component_widgets/profile_settings_page_background.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/settings/widgets/error_content_view.dart';
import 'package:brain_bench/presentation/settings/widgets/language_selection_view.dart';
import 'package:brain_bench/presentation/settings/widgets/light_dark_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SettingsPage');

class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key});

  // Helper function to determine the switch state based on theme mode and current brightness
  bool _calculateIsSwitchOn(
      AsyncValue<ThemeMode> themeModeAsyncValue, bool isDarkMode) {
    // Use the value if available (even in error state due to copyWithPrevious)
    final currentThemeMode = themeModeAsyncValue.valueOrNull;
    if (currentThemeMode != null) {
      switch (currentThemeMode) {
        case ThemeMode.dark:
          return true;
        case ThemeMode.light:
          return false;
        case ThemeMode.system:
          // If system is selected, the switch reflects the actual current mode
          return isDarkMode;
      }
    }
    // Default to reflecting the current mode if data isn't available (initial load?)
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor = isDarkMode
        ? BrainBenchColors.flutterSky.withAlpha((0.8 * 255).toInt())
        : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());
    final Color dividerColor = isDarkMode
        ? BrainBenchColors.cloudCanvas.withAlpha((0.3 * 255).toInt())
        : BrainBenchColors.deepDive.withAlpha((0.3 * 255).toInt());

    // --- Watch States ---
    final themeModeAsyncValue = ref.watch(themeModeNotifierProvider);
    final localeAsyncValue =
        ref.watch(localeNotifierProvider); // Watch locale state

    // --- Calculate Theme States ---
    final bool isSwitchOn =
        _calculateIsSwitchOn(themeModeAsyncValue, isDarkMode);
    final bool isThemeBusy = themeModeAsyncValue.isLoading ||
        themeModeAsyncValue.isRefreshing ||
        themeModeAsyncValue.isReloading;
    final bool hasThemeSaveError =
        themeModeAsyncValue is AsyncError && themeModeAsyncValue.hasValue;

    // --- Calculate Locale States ---
    final bool isLocaleBusy = localeAsyncValue.isLoading ||
        localeAsyncValue.isRefreshing ||
        localeAsyncValue.isReloading;
    final bool hasLocaleSaveError =
        localeAsyncValue is AsyncError && localeAsyncValue.hasValue;

    // --- Theme Change Handler ---
    void handleThemeChange(bool newValue) async {
      if (isThemeBusy || hasThemeSaveError) {
        return; // Don't change if busy or in error state
      }
      _logger.info('Theme mode toggled via Switch: $newValue');
      await ref.read(themeModeNotifierProvider.notifier).setThemeMode(
            newValue ? ThemeMode.dark : ThemeMode.light,
          );
    }

    // --- Theme Refresh Handler (for error recovery) ---
    void handleThemeRefresh() async {
      if (isThemeBusy) return; // Don't refresh if already busy
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
      if (isLocaleBusy) return; // Don't refresh if already busy
      _logger.info('Attempting to refresh locale due to previous error...');
      await ref.read(localeNotifierProvider.notifier).refreshLocale();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(localizations
                  .settingsLocaleRefreshed)), // Add this localization string
        );
      }
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
                      // --- Theme Row ---
                      Row(
                        children: [
                          Text(
                            localizations.settingsThemeToggleLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          // Show different UI based on state: Error > Busy > Switch
                          if (hasThemeSaveError)
                            ErrorContentView(
                              // Using the dedicated widget here
                              theme: theme,
                              isBusy: isThemeBusy, // Pass busy state
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
                          // Show different UI based on state: Error > Busy > Selection
                          if (hasLocaleSaveError) // Highest priority: Show error and refresh button
                            ErrorContentView(
                              // Re-using the ErrorContentView
                              theme: theme,
                              isBusy: isLocaleBusy, // Pass busy state
                              localizations: localizations,
                              handleRefresh:
                                  handleLocaleRefresh, // Use locale refresh handler
                            )
                          else if (isLocaleBusy) // Next priority: Show loading indicator
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else // Default: Show the language selection view
                            // Pass disabled state to LanguageSelectionView if needed
                            // Assuming LanguageSelectionView handles its own internal state
                            // or accepts an 'enabled' parameter. If not, you might need to adjust it.
                            LanguageSelectionView(
                                // Example: Pass enabled state if LanguageSelectionView supports it
                                // isEnabled: !(isLocaleBusy || hasLocaleSaveError),
                                ),
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
