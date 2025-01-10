import 'package:brain_bench/core/styles/text_theme.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: BrainBenchColors.blueprintBlue,
  scaffoldBackgroundColor: BrainBenchColors.cloudCanvas,
  textTheme: BrainBenchTextTheme.textTheme(Brightness.light),
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
  scaffoldBackgroundColor: BrainBenchColors.deepDive,
  textTheme: BrainBenchTextTheme.textTheme(Brightness.dark),
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
  )
      .copyWith(secondary: BrainBenchColors.flutterSky)
      .copyWith(surface: BrainBenchColors.deepDive),
);
