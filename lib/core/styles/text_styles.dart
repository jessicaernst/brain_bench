import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle loginSignUpTitle(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.21,
      letterSpacing: 0.4,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle title1(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle title2SemiBold(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle title2Bold(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle subtitleBold(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle bodyRegular(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle bodyEmphasized(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle sourceCode(BuildContext context) {
    return GoogleFonts.spaceMono(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: -1.28,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle brainBench(BuildContext context) {
    return GoogleFonts.audiowide(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: -1.92,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle brainBenchLogo(BuildContext context) {
    return GoogleFonts.audiowide(
      fontSize: 38.45,
      fontWeight: FontWeight.w400,
      letterSpacing: -3.08,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }

  static TextStyle buttonLabel(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.light
          ? BrainBenchColors.deepDive
          : BrainBenchColors.cloudCanvas,
    );
  }
}
