import 'package:brain_bench/core/styles/theme_data.dart';
import 'package:brain_bench/core/widgets/darkmode_btn.dart';
import 'package:brain_bench/core/widgets/lightmode_btn.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrainBenchApp extends StatelessWidget {
  const BrainBenchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Assets.images.dashLogo.image(
                  width: 350,
                  height: 350,
                ),
              ),
              /* Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.displayMedium,
              ), */
              const SizedBox(height: 20),
              LightmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
              const SizedBox(height: 20),
              DarkmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
