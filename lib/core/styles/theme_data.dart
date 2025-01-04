import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: BrainBenchColors.blueprintBlue,
  scaffoldBackgroundColor: BrainBenchColors.cloudCanvas,
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
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: BrainBenchColors.flutterSky,
  scaffoldBackgroundColor: BrainBenchColors
      .deepDive, // Note: accentColor is deprecated, consider using colorScheme
  colorScheme: const ColorScheme.dark(
    surface: BrainBenchColors.deepDive,
    secondary: BrainBenchColors.flutterSky,
  )
      .copyWith(secondary: BrainBenchColors.flutterSky)
      .copyWith(surface: BrainBenchColors.deepDive),
);
