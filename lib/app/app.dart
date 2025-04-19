import 'dart:io';
import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/theme_data.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('BrainBenchApp');

class BrainBenchApp extends ConsumerWidget {
  const BrainBenchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    final currentThemeModeAsync = ref.watch(themeModeNotifierProvider);

    final currentThemeMode =
        currentThemeModeAsync.valueOrNull ?? ThemeMode.system;

    final Brightness effectiveBrightness = currentThemeModeAsync.when(
      data: (themeMode) {
        return switch (themeMode) {
          ThemeMode.light => Brightness.light,
          ThemeMode.dark => Brightness.dark,
          ThemeMode.system => MediaQuery.platformBrightnessOf(context),
        };
      },
      loading: () => MediaQuery.platformBrightnessOf(context),
      error: (_, __) => MediaQuery.platformBrightnessOf(context),
    );

    final isAppEffectivelyDark = effectiveBrightness == Brightness.dark;

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isAppEffectivelyDark ? Brightness.light : Brightness.dark,
        ),
      );
    }

    final currentLocaleAsync = ref.watch(localeNotifierProvider);
    _logger.info('BrainBenchApp build: Watched locale is $currentLocaleAsync');

    return currentLocaleAsync.when(
      data: (currentLocale) {
        return MaterialApp.router(
          title: 'Brain Bench',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLanguages.keys.toList(),
          locale: currentLocale,
          theme: BrainBenchTheme.lightTheme,
          darkTheme: BrainBenchTheme.darkTheme,
          themeMode: currentThemeMode,
          routerConfig: router,
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        _logger.severe('Error loading locale for app', error, stackTrace);
        return const Center(
          child: Icon(Icons.error_outline),
        );
      },
    );
  }
}
