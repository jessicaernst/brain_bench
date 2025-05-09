import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:flutter/material.dart';
import 'package:gradient_design_btn/gradient_design_btn.dart';

class LightmodeBtn extends StatelessWidget {
  const LightmodeBtn({
    super.key,
    required this.title,
    required this.onPressed,
    this.isActive = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 48),
    this.width,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  final EdgeInsetsGeometry padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GradientDesignBtn(
      isActive: isActive,
      enableBlur: true,
      width: width,
      blurSigma: 5,
      padding: padding,
      title: Text(
        title,
        style: TextTheme.of(context).labelLarge,
      ),
      activeGradient: BrainBenchGradients.dashGradient,
      inactiveGradient: BrainBenchGradients.inactiveDashGradient,
      overlayGradient: BrainBenchGradients.btnOverlayGradient,
      strokeGradient: BrainBenchGradients.btnStrokeGradient,
      borderRadius: 30,
      height: 35,
      onPressed: onPressed,
    );
  }
}
