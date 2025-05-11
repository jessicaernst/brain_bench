import 'dart:ui';

import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:flutter/material.dart';

/// A card widget that displays an active news carousel.
class ActiveNewsCarouselCard extends StatelessWidget {
  const ActiveNewsCarouselCard({super.key, required this.content});

  /// The content to be displayed inside the card.
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

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
                        (0.7 * 255).toInt(),
                      ),
              boxShadow: isDarkMode ? [] : _shadows,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              height: 347,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient:
                    isDarkMode
                        ? BrainBenchGradients.authCardGradientDark
                        : BrainBenchGradients.authCardGradientLight,
                border: Border.all(
                  color: BrainBenchColors.btnStroke,
                  width: 0.7,
                ),
              ),
              //padding: const EdgeInsets.all(32),
              child: content,
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
