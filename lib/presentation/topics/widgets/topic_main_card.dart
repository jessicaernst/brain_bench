import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class TopicMainCard extends StatelessWidget {
  const TopicMainCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.isExpanded,
    required this.isDarkMode,
  });

  final String title;
  final VoidCallback onTap;
  final bool isExpanded;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: BrainBenchColors.deepDive.withAlpha((0.1 * 255).toInt()),
              blurRadius: 27,
              offset: const Offset(0, 68),
            ),
            BoxShadow(
              color: BrainBenchColors.deepDive.withAlpha((0.05 * 255).toInt()),
              blurRadius: 23,
              offset: const Offset(0, 38),
            ),
            BoxShadow(
              color: BrainBenchColors.deepDive.withAlpha((0.09 * 255).toInt()),
              blurRadius: 17,
              offset: const Offset(0, 17),
            ),
            BoxShadow(
              color: BrainBenchColors.deepDive.withAlpha((0.1 * 255).toInt()),
              blurRadius: 9,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Assets.appIcons.evo4.image(
              width: 55,
              height: 55,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.expand_more,
                size: 30,
                color: isDarkMode
                    ? BrainBenchColors.cloudCanvas
                    : BrainBenchColors.deepDive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
