import 'package:brain_bench/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: BrainBenchColors.blueprintBlue,
  scaffoldBackgroundColor: BrainBenchColors.cloudCanvas,
  textTheme: TextTheme(
    displayLarge: TextStyles.brainBenchLogo,
    displayMedium: TextStyles.brainBench,
    headlineLarge: TextStyles.loginSignUpTitle,
    headlineMedium: TextStyles.title1,
    headlineSmall: TextStyles.title2Bold,
    titleLarge: TextStyles.title2SemiBold,
    titleMedium: TextStyles.subtitleBold,
    titleSmall: TextStyles.subtitle,
    bodyLarge: TextStyles.bodyEmphasized,
    bodyMedium: TextStyles.bodyRegular,
    bodySmall: TextStyles.bodySmall,
    labelLarge: TextStyles.buttonLabel,
    labelSmall: TextStyles.sourceCode,
  ),
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
  textTheme: TextTheme(
    displayLarge: TextStyles.brainBenchLogo,
    displayMedium: TextStyles.brainBench,
    headlineLarge: TextStyles.loginSignUpTitle,
    headlineMedium: TextStyles.title1,
    headlineSmall: TextStyles.title2Bold,
    titleLarge: TextStyles.title2SemiBold,
    titleMedium: TextStyles.subtitleBold,
    titleSmall: TextStyles.subtitle,
    bodyLarge: TextStyles.bodyEmphasized,
    bodyMedium: TextStyles.bodyRegular,
    bodySmall: TextStyles.bodySmall,
    labelLarge: TextStyles.buttonLabel,
    labelSmall: TextStyles.sourceCode,
  ),
  colorScheme: const ColorScheme.dark(
    surface: BrainBenchColors.deepDive,
    secondary: BrainBenchColors.flutterSky,
  )
      .copyWith(secondary: BrainBenchColors.flutterSky)
      .copyWith(surface: BrainBenchColors.deepDive),
);
