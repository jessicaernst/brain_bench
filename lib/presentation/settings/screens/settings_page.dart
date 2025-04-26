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

    // Watch the theme state
    final themeModeAsyncValue = ref.watch(themeModeNotifierProvider);

    // Calculate switch state based on potentially optimistic value
    final bool isSwitchOn =
        _calculateIsSwitchOn(themeModeAsyncValue, isDarkMode);

    // Determine if the theme provider is busy (loading, saving, refreshing)
    final bool isThemeBusy = themeModeAsyncValue.isLoading ||
        themeModeAsyncValue.isRefreshing ||
        themeModeAsyncValue.isReloading; // isReloading might occur during save

    // Check specifically for the error state after an optimistic update failed
    final bool hasSaveError =
        themeModeAsyncValue is AsyncError && themeModeAsyncValue.hasValue;

    // --- Theme Change Handler ---
    void handleThemeChange(bool newValue) async {
      if (isThemeBusy || hasSaveError)
        return; // Don't change if busy or in error state
      _logger.info('Theme mode toggled via Switch: $newValue');
      // No try-catch needed here, as the provider handles errors internally
      // and updates the state accordingly (which we watch).
      await ref.read(themeModeNotifierProvider.notifier).setThemeMode(
            newValue ? ThemeMode.dark : ThemeMode.light,
          );
    }

    // --- Refresh Handler (for error recovery) ---
    void handleRefresh() async {
      if (isThemeBusy) return; // Don't refresh if already busy
      _logger.info('Attempting to refresh theme due to previous error...');
      await ref.read(themeModeNotifierProvider.notifier).refreshTheme();
      // Optional: Show feedback after refresh attempt
      if (context.mounted) {
        // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.settingsThemeRefreshed)),
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
                          if (hasSaveError) // Highest priority: Show error and refresh button
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline,
                                    color: theme.colorScheme.error, size: 20),
                                const SizedBox(width: 8),
                                // Use TextButton for less visual weight than ElevatedButton
                                TextButton(
                                  onPressed: isThemeBusy
                                      ? null
                                      : handleRefresh, // Disable if refresh is in progress
                                  child: Text(
                                      localizations.settingsRefreshButtonLabel),
                                ),
                              ],
                            )
                          else if (isThemeBusy) // Next priority: Show loading indicator
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else // Default: Show the switch
                            LightDarkModeSwitch(
                              value: isSwitchOn,
                              // Disable switch if busy (redundant due to outer check, but safe)
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
                          LanguageSelectionView(),
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
