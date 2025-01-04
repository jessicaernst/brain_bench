import 'dart:ui';

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
  static const Color correctAnswerGlass = Color.fromARGB(102, 9, 204, 232);
  static const Color correctAnswerGlassLight = Color.fromARGB(26, 9, 204, 232);

  // Dark Mode Glass
  static const Color darkModeGlass = Color.fromARGB(102, 93, 200, 248);
  static const Color darkModeGlassLight = Color.fromARGB(26, 93, 200, 248);

  // Light Mode Glass
  static const Color lightModeGlass = Color.fromARGB(102, 101, 160, 212);
  static const Color lightModeGlassLight = Color.fromARGB(26, 101, 160, 212);

  // False Question Glass
  static const Color falseQuestionGlass = Color.fromARGB(102, 236, 87, 211);
  static const Color falseQuestionGlassLight = Color.fromARGB(26, 236, 87, 207);

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
}
