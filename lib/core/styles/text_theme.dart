import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

abstract class BrainBenchTextTheme {
  static TextTheme textTheme(Brightness brightness) {
    return TextTheme(
      displayLarge: BrainBenchTextStyles.loginSignUpTitle(),
      displayMedium: BrainBenchTextStyles.brainBenchLogo(),
      displaySmall: BrainBenchTextStyles.brainBench(),
      headlineLarge: BrainBenchTextStyles.title1(),
      headlineMedium: BrainBenchTextStyles.title2Bold(),
      headlineSmall: BrainBenchTextStyles.title2SemiBold(),
      titleMedium: BrainBenchTextStyles.subtitle(),
      titleSmall: BrainBenchTextStyles.subtitleBold(),
      bodyLarge: BrainBenchTextStyles.bodyEmphasized(),
      bodyMedium: BrainBenchTextStyles.bodyRegular(),
      bodySmall: BrainBenchTextStyles.bodySmall(),
      labelLarge: BrainBenchTextStyles.buttonLabel(),
      labelSmall: BrainBenchTextStyles.sourceCode(),
    ).apply(
      bodyColor: brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
      displayColor: brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }
}
