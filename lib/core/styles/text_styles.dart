import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static final TextStyle loginSignUpTitle = GoogleFonts.urbanist(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.21,
    letterSpacing: 0.4,
  );

  static final TextStyle title1 = GoogleFonts.urbanist(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle title2SemiBold = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle title2Bold = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle subtitle = GoogleFonts.urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle subtitleBold = GoogleFonts.urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle bodyRegular = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyEmphasized = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodySmall = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle sourceCode = GoogleFonts.spaceMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.28,
  );

  static final TextStyle brainBench = GoogleFonts.audiowide(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.92,
  );

  static final TextStyle brainBenchLogo = GoogleFonts.audiowide(
    fontSize: 38.45,
    fontWeight: FontWeight.w400,
    letterSpacing: -3.08,
  );

  static final TextStyle buttonLabel = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
