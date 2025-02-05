import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorBarView extends StatelessWidget {
  const ProgressIndicatorBarView({
    super.key,
  });

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
              height: 10, // Höhe des Balkens
              color: BrainBenchColors.progressIndicatorBackground,
            ),
          ),
          // Fortschritt
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5, // Fortschritt (z.B. 50%)
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
