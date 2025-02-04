import 'dart:ui';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:flutter/material.dart';

class TopicExpandableContent extends StatelessWidget {
  const TopicExpandableContent({
    super.key,
    required this.cardWidth,
    required this.description,
    required this.isDarkMode,
    required this.onPressed,
    required this.isExpanded,
  });

  final double cardWidth;
  final String description;
  final bool isDarkMode;
  final VoidCallback onPressed;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      //margin: const EdgeInsets.only(top: 1),
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: cardWidth - 32,
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? BrainBenchGradients.topicCardDarkGradient
                    : BrainBenchGradients.topicCardLightGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LightDarkSwitchBtn(
                      title: 'Start',
                      isActive: true,
                      isDarkMode: isDarkMode,
                      onPressed: onPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
