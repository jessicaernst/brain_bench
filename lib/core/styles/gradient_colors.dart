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

  static final LinearGradient inactiveDashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.codeBreeze.withAlpha((0.5 * 255).toInt()),
      BrainBenchColors.flutterSky.withAlpha((0.5 * 255).toInt()),
      BrainBenchColors.blueprintBlue.withAlpha((0.5 * 255).toInt()),
      BrainBenchColors.deepDive70.withAlpha((0.5 * 255).toInt()),
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

  static LinearGradient correctAnswerGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
    colors: [
      BrainBenchColors.correctAnswerGlass.withAlpha((0.4 * 255).toInt()),
      BrainBenchColors.correctAnswerGlass.withAlpha((0.1 * 255).toInt())
    ],
  );

  static LinearGradient falseQuestionGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
    colors: [
      BrainBenchColors.falseQuestionGlass.withAlpha((0.4 * 255).toInt()),
      BrainBenchColors.falseQuestionGlass.withAlpha((0.1 * 255).toInt())
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

  // Button Gradients
  static final LinearGradient btnStrokeGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha((0.3 * 255).toInt()),
      Colors.white.withAlpha((0.0 * 255).toInt()),
      Colors.white.withAlpha((0.0 * 255).toInt()),
      Colors.white.withAlpha((1.0 * 255).toInt()),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.0, 0.19, 0.83, 1.0],
  );

  static final LinearGradient btnOverlayGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(
        (0.3 * 255).toInt(),
      ),
      Colors.transparent,
    ],
  );

  static final LinearGradient btnOverlayGradientDark = LinearGradient(
    colors: [
      Colors.white.withAlpha(
        (0.4 * 255).toInt(),
      ),
      Colors.transparent,
    ],
  );

  // Topic Card Gradients
  static final LinearGradient topicCardDarkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.flutterSky.withAlpha((0.0 * 255).toInt()),
      BrainBenchColors.flutterSky.withAlpha((0.2 * 255).toInt()),
    ],
    stops: const [0.1, 1.0],
  );

  static final LinearGradient topicCardLightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BrainBenchColors.blueprintBlue.withAlpha((0.0 * 255).toInt()),
      BrainBenchColors.blueprintBlue.withAlpha((0.2 * 255).toInt()),
    ],
    stops: const [0.1, 1.0],
  );

  // Answer Card Gradients
  static final LinearGradient answerCardLightGradient = LinearGradient(
    colors: [
      BrainBenchColors.blueprintBlue.withAlpha((0.4 * 255).toInt()),
      BrainBenchColors.blueprintBlue.withAlpha((0.1 * 255).toInt()),
    ],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient answerCardDarkGradient = LinearGradient(
    colors: [
      BrainBenchColors.flutterSky.withAlpha((0.4 * 255).toInt()),
      BrainBenchColors.flutterSky.withAlpha((0.1 * 255).toInt()),
    ],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient answerContentCardLightGradient = LinearGradient(
    colors: [
      BrainBenchColors.blueprintBlue.withAlpha((0.0 * 255).toInt()),
      BrainBenchColors.blueprintBlue.withAlpha((0.2 * 255).toInt()),
    ],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient answerContentCardDarkGradient = LinearGradient(
    colors: [
      BrainBenchColors.flutterSky.withAlpha((0.0 * 255).toInt()),
      BrainBenchColors.flutterSky.withAlpha((0.2 * 255).toInt()),
    ],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient authCardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.lightModeGlass40,
      BrainBenchColors.lightModeGlass10,
    ],
  );

  static final LinearGradient authCardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BrainBenchColors.darkModeGlass40,
      BrainBenchColors.darkModeGlass10,
    ],
  );
}
