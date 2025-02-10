import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorBarView extends StatelessWidget {
  const ProgressIndicatorBarView({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // Hintergrund
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 10,
              color: BrainBenchColors.progressIndicatorBackground,
            ),
          ),
          // Fortschritt
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                height: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
