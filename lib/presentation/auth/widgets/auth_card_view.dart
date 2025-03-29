import 'dart:ui';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

class AuthCardView extends StatelessWidget {
  const AuthCardView({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Stack(
          children: [
            // 1. Shadow-Ebene mit weißer Hintergrundschicht
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: BrainBenchColors.cloudCanvas
                      .withAlpha((0.7 * 255).toInt()),
                  boxShadow: _shadows,
                ),
              ),
            ),
            // 2. Obere Glass/Gradient-Schicht mit Blur
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        BrainBenchColors.blueprintBlue
                            .withAlpha((0.4 * 255).toInt()),
                        BrainBenchColors.blueprintBlue
                            .withAlpha((0.1 * 255).toInt()),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withAlpha((0.7 * 255).toInt()),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<BoxShadow> _shadows = [
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.10 * 255).toInt()),
      blurRadius: 15,
      offset: const Offset(0, 7)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.09 * 255).toInt()),
      blurRadius: 27,
      offset: const Offset(0, 27)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.05 * 255).toInt()),
      blurRadius: 36,
      offset: const Offset(0, 60)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.01 * 255).toInt()),
      blurRadius: 43,
      offset: const Offset(0, 107)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.00 * 255).toInt()),
      blurRadius: 47,
      offset: const Offset(0, 167)),
];
