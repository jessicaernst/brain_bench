import 'package:brain_bench/core/styles/text_theme.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData getLightTheme({Brightness brightness = Brightness.light}) {
  return ThemeData(
    brightness: brightness,
    primaryColor: BrainBenchColors.blueprintBlue,
    scaffoldBackgroundColor: BrainBenchColors.cloudCanvas,
    textTheme: BrainBenchTextTheme.textTheme(brightness: brightness),
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
  );
}

ThemeData getDarkTheme({Brightness brightness = Brightness.dark}) {
  return ThemeData(
    brightness: brightness,
    primaryColor: BrainBenchColors.flutterSky,
    scaffoldBackgroundColor: BrainBenchColors.deepDive,
    textTheme: BrainBenchTextTheme.textTheme(brightness: brightness),
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
    colorScheme: const ColorScheme.dark(
      surface: BrainBenchColors.deepDive,
      secondary: BrainBenchColors.flutterSky,
    ).copyWith(
      surface: BrainBenchColors.deepDive,
    ),
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
  );
}
