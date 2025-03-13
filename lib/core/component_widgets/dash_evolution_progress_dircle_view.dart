import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/core/component_widgets/gradient_progress_indicator.dart';
import 'package:flutter/material.dart';

class DashEvolutionProgressCircleView extends StatelessWidget {
  const DashEvolutionProgressCircleView({
    super.key,
    required this.progress,
    this.size = 80.0, // Default size for the widget
  });

  final double progress;
  final double size;

  // Determines the image path based on the progress value
  // Progress is divided into ranges:
  // - 0.0 to <0.25: evolution1
  // - 0.25 to <0.75: evolution2
  // - 0.75 to <1.0: evolution3
  // - 1.0: evolution4
  String _getImagePath(double progress) {
    if (progress < 0.25) {
      return Assets.images.evolution1.path;
    } else if (progress < 0.75) {
      return Assets.images.evolution2.path;
    } else if (progress < 1.0) {
      return Assets.images.evolution3.path;
    } else {
      return Assets.images.evolution4.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which image to display based on the progress
    final imagePath = _getImagePath(progress);

    return Stack(
      alignment: Alignment.center, // Center-align both widgets
      children: [
        // The gradient progress indicator
        GradientProgressIndicator(
          progress: progress, // Progress value to display
          gradient: BrainBenchGradients.dashGradient, // Gradient color
          strokeWidth:
              size * 0.1, // Stroke width proportional to the widget size
          // *0.1 ensures the thickness scales with the overall size of the widget.
          // This keeps the visual balance consistent across different sizes.
          size: size, // Overall size of the progress indicator
        ),
        // The circular avatar in the center
        CircleAvatar(
          radius: size * 0.35, // Radius proportional to the widget size
          // *0.35 ensures that the circle (avatar) is smaller than the outer indicator,
          // creating an aesthetically pleasing size ratio between the progress indicator
          // and the inner image.
          backgroundImage:
              AssetImage(imagePath), // Dynamic image based on progress
          backgroundColor:
              Colors.transparent, // Transparent background to match design
        ),
      ],
    );
  }
}
