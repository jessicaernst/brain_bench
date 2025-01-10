import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// static Functions for Textstyles because they are not dependent on any instance and it is needed to get the context for the color switch between light and dark mode
abstract class BrainBenchTextStyles {
  static TextStyle loginSignUpTitle() {
    return GoogleFonts.urbanist(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.21,
      letterSpacing: 0.4,
    );
  }

  static TextStyle title1() {
    return GoogleFonts.urbanist(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle title2SemiBold() {
    return GoogleFonts.urbanist(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle title2Bold() {
    return GoogleFonts.urbanist(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle subtitle() {
    return GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle subtitleBold() {
    return GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle bodyRegular() {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyEmphasized() {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bodySmall() {
    return GoogleFonts.urbanist(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle sourceCode() {
    return GoogleFonts.spaceMono(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: -1.28,
    );
  }

  static TextStyle brainBench() {
    return GoogleFonts.audiowide(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: -1.92,
    );
  }

  static TextStyle brainBenchLogo() {
    return GoogleFonts.audiowide(
      fontSize: 38.45,
      fontWeight: FontWeight.w400,
      letterSpacing: -3.08,
    );
  }

  static TextStyle buttonLabel() {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
