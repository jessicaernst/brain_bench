import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

abstract class BrainBenchGradients {
  // Login Background Gradient
  static const LinearGradient loginBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.blueprintBlue,
      BrainBenchColors.blueprintBlue,
    ],
  );

  // Login Card Background Gradient
  static LinearGradient loginCardBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.blueprintBlue40,
      BrainBenchColors.blueprintBlue10,
    ],
  );

  // Dash Gradient
  static final LinearGradient dashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.codeBreeze,
      BrainBenchColors.flutterSky,
      BrainBenchColors.blueprintBlue,
      BrainBenchColors.deepDive70,
    ],
  );

  // Glass Gradients
  static final LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.white40, // 40% opacity white
      BrainBenchColors.white10, // 10% opacity white
    ],
  );

  static final LinearGradient darkModeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.flutterSky40,
      BrainBenchColors.flutterSky10,
    ],
  );

  static const LinearGradient correctAnswerGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.correctAnswerGlass,
      BrainBenchColors.correctAnswerGlassLight,
    ],
  );

  static const LinearGradient falseQuestionGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.falseQuestionGlass,
      BrainBenchColors.falseQuestionGlassLight,
    ],
  );

  static final LinearGradient newsCarouselCardBack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.flutterSky40,
      BrainBenchColors.flutterSky10,
    ],
  );

  static final LinearGradient newsCarouselCardTop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.deepDive,
      BrainBenchColors.flutterSky40,
      BrainBenchColors.flutterSky10,
    ],
  );
}
