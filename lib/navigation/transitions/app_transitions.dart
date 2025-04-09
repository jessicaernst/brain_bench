import 'package:flutter/material.dart';

// --- Transition Durations ---
const Duration transitionDuration = Duration(milliseconds: 350);
const Duration reverseTransitionDuration = Duration(milliseconds: 300);

// --- Transition Builders ---

/// Builds a slide-up transition (like a modal).
Widget buildSlideUpTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(0.0, 1.0); // Start from bottom
  const end = Offset.zero;
  final curve = Curves.easeInOut; // Use easeInOut curve

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Builds a Cupertino-style (iOS) slide transition from the right
/// with parallax effect on the outgoing screen, using easeInOut curve.
Widget buildCupertinoSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  final curve = Curves.easeInOut; // Use easeInOut curve

  // Slide in from right for the entering page
  final Animatable<Offset> slideInTween = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: curve));

  // Slide out slightly to the left for the exiting page (parallax)
  final Animatable<Offset> slideOutTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.3, 0.0), // Adjust -0.3 for desired parallax intensity
  ).chain(CurveTween(curve: curve));

  return SlideTransition(
    position:
        secondaryAnimation.drive(slideOutTween), // Apply parallax to outgoing
    child: SlideTransition(
      position: animation.drive(slideInTween), // Apply slide-in to incoming
      child: child,
    ),
  );
}
