import 'dart:ui';

import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:flutter/material.dart';

/// A card widget used in the inactive news carousel.
class InactiveNewsCarouselCard extends StatelessWidget {
  const InactiveNewsCarouselCard({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color:
                  isDarkMode
                      ? BrainBenchColors.deepDive
                      : BrainBenchColors.cloudCanvas.withAlpha(
                        (0.5 * 255).toInt(),
                      ),
              boxShadow: isDarkMode ? [] : _shadows,
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1.84, sigmaY: 1.84),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient:
                      isDarkMode
                          ? BrainBenchGradients.authCardGradientDark
                          : BrainBenchGradients.authCardGradientLight,
                  border: Border.all(
                    color: BrainBenchColors.btnStroke,
                    width: 0.7,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final List<BoxShadow> _shadows = [
  BoxShadow(
    color: BrainBenchColors.deepDive.withAlpha((0.27 * 255).toInt()),
    blurRadius: 21.76,
    offset: const Offset(0, 0),
  ),
];
