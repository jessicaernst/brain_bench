import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientProgressIndicator extends StatelessWidget {
  const GradientProgressIndicator({
    super.key,
    required this.progress,
    required this.gradient,
    this.strokeWidth = 8.0,
    this.size = 80.0,
  });

  final double progress;
  final Gradient gradient;
  final double strokeWidth;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Using CustomPaint to render the gradient progress indicator.
    // This delegates the actual painting to a separate painter class.
    return CustomPaint(
      size: Size.square(size), // Square area based on the size parameter.
      painter: _GradientProgressPainter(
        progress: progress,
        gradient: gradient,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

// Custom painter for the gradient progress indicator.
// Handles the drawing of the progress arc with rounded stroke caps.
class _GradientProgressPainter extends CustomPainter {
  _GradientProgressPainter({
    required this.progress,
    required this.gradient,
    required this.strokeWidth,
  });

  final double progress;
  final Gradient gradient;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Define the area for the gradient shader.
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Paint for the progress arc with the gradient shader.
    final Paint foregroundPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap =
              StrokeCap
                  .round // Rounded edges for the progress arc.
          ..strokeWidth = strokeWidth;

    // Calculate the center and radius for the progress arc.
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    // Calculate the sweep angle for the progress.
    final double sweepAngle = 2 * math.pi * progress;

    // Draw the progress arc.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2, // Start angle (top of the circle).
      sweepAngle,
      false, // Open arc (not filled).
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
