import 'package:flutter/material.dart';

abstract class BrainBenchColors {
  // Solid Colors
  static const Color deepDive = Color.fromARGB(255, 4, 30, 60);
  static const Color flutterSky = Color.fromARGB(255, 93, 200, 248);
  static const Color blueprintBlue = Color.fromARGB(255, 101, 160, 212);
  static const Color codeBreeze = Color.fromARGB(255, 175, 225, 255);
  static const Color logoGold = Color.fromARGB(255, 255, 215, 0);
  static const Color cloudCanvas = Color.fromARGB(255, 255, 255, 249);
  static const Color btnLayerOpacity = Color.fromARGB(77, 255, 255, 255);
  static const Color btnStroke = Color.fromARGB(255, 255, 255, 255);

  // Correct Answer Glass
  static const Color correctAnswerGlass = Color.fromARGB(255, 9, 204, 232);
  static const Color correctAnswerGlassLight = Color.fromARGB(255, 9, 204, 232);
  static final Color correctAnswerGlass40 =
      correctAnswerGlass.withAlpha((0.4 * 255).toInt());
  static final Color correctAnswerGlass10 =
      correctAnswerGlassLight.withAlpha((0.1 * 255).toInt());

// Dark Mode Glass
  static const Color darkModeGlass = Color.fromARGB(255, 93, 200, 248);
  static const Color darkModeGlassLight = Color.fromARGB(255, 93, 200, 248);
  static final Color darkModeGlass40 =
      darkModeGlass.withAlpha((0.4 * 255).toInt());
  static final Color darkModeGlass50 =
      darkModeGlass.withAlpha((0.5 * 255).toInt());
  static final Color darkModeGlass10 =
      darkModeGlassLight.withAlpha((0.1 * 255).toInt());

// Light Mode Glass
  static const Color lightModeGlass = Color.fromARGB(255, 101, 160, 212);
  static const Color lightModeGlassLight = Color.fromARGB(255, 101, 160, 212);
  static final Color lightModeGlass40 =
      lightModeGlass.withAlpha((0.4 * 255).toInt());
  static final Color lightModeGlass10 =
      lightModeGlassLight.withAlpha((0.1 * 255).toInt());

// False Question Glass
  static const Color falseQuestionGlass = Color.fromARGB(255, 236, 87, 211);
  static const Color falseQuestionGlassLight =
      Color.fromARGB(255, 236, 87, 207);
  static final Color falseQuestionGlass40 =
      falseQuestionGlass.withAlpha((0.4 * 255).toInt());
  static final Color falseQuestionGlass10 =
      falseQuestionGlassLight.withAlpha((0.1 * 255).toInt());

  // Opacities for Deep Dive
  static final Color deepDive70 = deepDive.withAlpha((0.7 * 255).toInt());
  static final Color deepDive50 = deepDive.withAlpha((0.5 * 255).toInt());
  static final Color deepDive30 = deepDive.withAlpha((0.3 * 255).toInt());

  // Opacities for Blueprint Blue
  static final Color blueprintBlue40 =
      blueprintBlue.withAlpha((0.4 * 255).toInt());
  static final Color blueprintBlue10 =
      blueprintBlue.withAlpha((0.1 * 255).toInt());

  // Flutter Sky with varying opacities
  static final Color flutterSky40 = flutterSky.withAlpha((0.4 * 255).toInt());
  static final Color flutterSky30 = flutterSky.withAlpha((0.3 * 255).toInt());
  static final Color flutterSky10 = flutterSky.withAlpha((0.1 * 255).toInt());

  // white opacity
  static final Color white40 = Colors.white.withAlpha((0.4 * 255).toInt());
  static final Color white10 = Colors.white.withAlpha((0.1 * 255).toInt());

  /// A medium gray for the inactive state of the toggle buttons.
  static const Color inactiveGray = Color.fromARGB(255, 150, 150, 150);

  /// A lighter version of [inactiveGray] for a less intense inactive state.
  static const Color inactiveGrayLight = Color.fromARGB(255, 200, 200, 200);

  static final Color inactiveGray20 =
      inactiveGray.withAlpha((0.2 * 255).toInt());

  static final Color inactiveGrayLight10 =
      inactiveGrayLight.withAlpha((0.1 * 255).toInt());

  static final Color progressIndicatorBackground =
      const Color.fromARGB(255, 120, 120, 128).withAlpha((0.16 * 255).toInt());
}
