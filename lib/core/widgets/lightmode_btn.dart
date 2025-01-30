import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/core/widgets/gradient_design_btn.dart';
import 'package:flutter/material.dart';

class LightmodeBtn extends StatelessWidget {
  const LightmodeBtn({
    super.key,
    required this.title,
    required this.onPressed,
    this.isActive = true,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GradientDesignBtn(
      isActive: isActive,
      enableBlur: true,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
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
