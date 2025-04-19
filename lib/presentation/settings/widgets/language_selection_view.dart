import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/settings/widgets/error_indicator.dart';
import 'package:brain_bench/presentation/settings/widgets/language_selector.dart';
import 'package:brain_bench/presentation/settings/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionView extends ConsumerWidget {
  LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsyncValue = ref.watch(localeNotifierProvider);
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.blueprintBlue;

    return localeAsyncValue.when(
      data: (currentLocale) => LanguageSelector(
        currentLocale: currentLocale,
        textColor: textColor,
        isDarkMode: isDarkMode,
      ),
      loading: () => LoadingIndicator(textColor: textColor),
      error: (error, stackTrace) => ErrorIndicator(
        error: error,
        stackTrace: stackTrace,
        textColor: textColor,
      ),
    );
  }
}
