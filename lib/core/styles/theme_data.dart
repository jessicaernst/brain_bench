import 'package:brain_bench/core/styles/text_styles.dart';
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
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: BrainBenchColors.blueprintBlue,
          circularTrackColor: BrainBenchColors.cloudCanvas,
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
        expansionTileTheme: const ExpansionTileThemeData(
          collapsedIconColor: BrainBenchColors.deepDive,
          iconColor: BrainBenchColors.deepDive,
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          tilePadding: EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
          collapsedShape: Border(),
          shape: Border(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: BrainBenchTextStyles.bodyRegular().copyWith(
            color: BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt()),
          ),
          filled: true,
          fillColor: BrainBenchColors.cloudCanvas,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 60, 60, 67)
                  .withAlpha((0.29 * 255).toInt()),
              width: 0.7,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 60, 60, 67)
                  .withAlpha((0.29 * 255).toInt()),
              width: 1.2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
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
        expansionTileTheme: const ExpansionTileThemeData(
          collapsedIconColor: BrainBenchColors.cloudCanvas,
          iconColor: BrainBenchColors.cloudCanvas,
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          tilePadding: EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          collapsedShape: Border(),
          shape: Border(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: BrainBenchTextStyles.bodyRegular().copyWith(
            color: BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt()),
          ),
          filled: true,
          fillColor: BrainBenchColors.cloudCanvas,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 60, 60, 67)
                  .withAlpha((0.29 * 255).toInt()),
              width: 0.7,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 60, 60, 67)
                  .withAlpha((0.29 * 255).toInt()),
              width: 1.2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
