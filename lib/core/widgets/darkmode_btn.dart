import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/core/widgets/gradient_design_btn.dart';
import 'package:flutter/material.dart';

class DarkmodeBtn extends StatelessWidget {
  const DarkmodeBtn({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isActive,
    this.padding = const EdgeInsets.symmetric(horizontal: 48),
  });

  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GradientDesignBtn(
      isActive: isActive,
      enableBlur: true,
      blurSigma: 15,
      padding: padding,
      title: Text(
        title,
        style: TextTheme.of(context).labelLarge,
      ),
      activeGradient: BrainBenchGradients.dashGradient,
      inactiveGradient: BrainBenchGradients.inactiveDashGradient,
      overlayGradient: BrainBenchGradients.btnOverlayGradientDark,
      strokeGradient: BrainBenchGradients.btnStrokeGradient,
      borderRadius: 30,
      height: 35,
      onPressed: onPressed,
    );
  }
}
