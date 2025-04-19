import 'dart:io';
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/theme_data.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrainBenchApp extends ConsumerWidget {
  const BrainBenchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    final currentThemeMode = ref.watch(themeModeNotifierProvider);

    Brightness effectiveBrightness;
    switch (currentThemeMode) {
      case ThemeMode.light:
        effectiveBrightness = Brightness.light;
        break;
      case ThemeMode.dark:
        effectiveBrightness = Brightness.dark;
        break;
      case ThemeMode.system:
        effectiveBrightness = MediaQuery.platformBrightnessOf(context);
    }
    final bool isAppEffectivelyDark = effectiveBrightness == Brightness.dark;

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isAppEffectivelyDark ? Brightness.light : Brightness.dark,
        ),
      );
    }

    return MaterialApp.router(
      title: 'Brain Bench',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      theme: BrainBenchTheme.lightTheme,
      darkTheme: BrainBenchTheme.darkTheme,
      themeMode: currentThemeMode,
      routerConfig: router,
    );
  }
}
