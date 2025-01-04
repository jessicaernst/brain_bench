import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/text_styles.dart';
import 'package:brain_bench/core/styles/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrainBenchApp extends StatelessWidget {
  const BrainBenchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyles.brainBenchLogo(context).copyWith(
            color: BrainBenchColors.logoGold,
          ),
        ),
      ),
    );
  }
}
