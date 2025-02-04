import 'package:brain_bench/core/styles/text_theme.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class BrainBenchTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: BrainBenchColors.blueprintBlue,
        scaffoldBackgroundColor: BrainBenchColors.cloudCanvas,
        textTheme: BrainBenchTextTheme.textTheme(brightness: Brightness.light),
        buttonTheme: const ButtonThemeData(
          buttonColor: BrainBenchColors.blueprintBlue,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: BrainBenchColors.cloudCanvas,
            backgroundColor: BrainBenchColors.blueprintBlue,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: BrainBenchColors.deepDive,
            textStyle:
                BrainBenchTextTheme.textTheme(brightness: Brightness.light)
                    .labelLarge,
          ),
        ),
        colorScheme: const ColorScheme.light(
          surface: BrainBenchColors.cloudCanvas,
          secondary: BrainBenchColors.blueprintBlue,
        ).copyWith(surface: BrainBenchColors.cloudCanvas),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: BrainBenchColors.cloudCanvas,
          selectedItemColor: BrainBenchColors.blueprintBlue,
          unselectedItemColor: BrainBenchColors.blueprintBlue.withAlpha(150),
          selectedLabelStyle: const TextStyle(
            color: BrainBenchColors.blueprintBlue,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            color: BrainBenchColors.blueprintBlue.withAlpha(150),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: BrainBenchColors.cloudCanvas,
          scrolledUnderElevation: 0.0,
          elevation: 0,
          shadowColor: Colors.transparent,
          titleTextStyle:
              BrainBenchTextTheme.textTheme(brightness: Brightness.light)
                  .headlineSmall,
          iconTheme: const IconThemeData(
            color: BrainBenchColors.blueprintBlue,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: BrainBenchColors.flutterSky,
        scaffoldBackgroundColor: BrainBenchColors.deepDive,
        textTheme: BrainBenchTextTheme.textTheme(brightness: Brightness.dark),
        buttonTheme: const ButtonThemeData(
          buttonColor: BrainBenchColors.flutterSky,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: BrainBenchColors.deepDive,
            backgroundColor: BrainBenchColors.flutterSky,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: BrainBenchColors.cloudCanvas,
            textStyle:
                BrainBenchTextTheme.textTheme(brightness: Brightness.dark)
                    .labelLarge,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          surface: BrainBenchColors.deepDive,
          secondary: BrainBenchColors.flutterSky,
        ).copyWith(surface: BrainBenchColors.deepDive),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: BrainBenchColors.deepDive,
          selectedItemColor: BrainBenchColors.flutterSky,
          unselectedItemColor: BrainBenchColors.flutterSky.withAlpha(150),
          selectedLabelStyle: const TextStyle(
            color: BrainBenchColors.flutterSky,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            color: BrainBenchColors.flutterSky.withAlpha(150),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: BrainBenchColors.deepDive,
          scrolledUnderElevation: 0.0,
          elevation: 0,
          shadowColor: Colors.transparent,
          titleTextStyle:
              BrainBenchTextTheme.textTheme(brightness: Brightness.dark)
                  .headlineSmall,
          iconTheme: const IconThemeData(
            color: BrainBenchColors.flutterSky,
          ),
        ),
      );
}
