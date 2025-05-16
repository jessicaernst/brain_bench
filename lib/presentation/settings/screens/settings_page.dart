import 'package:brain_bench/business_logic/locale/locale_provider.dart'; // Import locale provider
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/close_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/backgrounds/profile_settings_page_background.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/settings/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key});

  // Helper function to determine the switch state based on theme mode and current brightness
  bool _calculateIsSwitchOn(
    AsyncValue<ThemeMode> themeModeAsyncValue,
    bool isDarkMode,
  ) {
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
    final Color iconColor =
        isDarkMode
            ? BrainBenchColors.flutterSky.withAlpha((0.8 * 255).toInt())
            : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());
    final Color dividerColor =
        isDarkMode
            ? BrainBenchColors.cloudCanvas.withAlpha((0.3 * 255).toInt())
            : BrainBenchColors.deepDive.withAlpha((0.3 * 255).toInt());

    // --- Watch States ---
    final themeModeAsyncValue = ref.watch(themeModeNotifierProvider);
    final localeAsyncValue = ref.watch(
      localeNotifierProvider,
    ); // Watch locale state

    // --- Calculate Theme States ---
    final bool isSwitchOn = _calculateIsSwitchOn(
      themeModeAsyncValue,
      isDarkMode,
    );
    final bool isThemeBusy =
        themeModeAsyncValue.isLoading ||
        themeModeAsyncValue.isRefreshing ||
        themeModeAsyncValue.isReloading;
    final bool hasThemeSaveError =
        themeModeAsyncValue is AsyncError && themeModeAsyncValue.hasValue;

    // --- Calculate Locale States ---
    final bool isLocaleBusy =
        localeAsyncValue.isLoading ||
        localeAsyncValue.isRefreshing ||
        localeAsyncValue.isReloading;
    final bool hasLocaleSaveError =
        localeAsyncValue is AsyncError && localeAsyncValue.hasValue;

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
                child: SettingsCard(
                  localizations: localizations,
                  hasThemeSaveError: hasThemeSaveError,
                  theme: theme,
                  isThemeBusy: isThemeBusy,
                  isSwitchOn: isSwitchOn,
                  iconColor: iconColor,
                  dividerColor: dividerColor,
                  hasLocaleSaveError: hasLocaleSaveError,
                  isLocaleBusy: isLocaleBusy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
