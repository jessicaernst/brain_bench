import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that represents the expandable content of a card.
class CardExpandableContent extends HookConsumerWidget {
  /// Constructs a [CardExpandableContent].
  ///
  /// The [isExpanded] parameter determines whether the content is expanded or collapsed.
  /// The [padding] parameter specifies the horizontal padding of the content.
  /// The [lightGradient] and [darkGradient] parameters define the gradients used for the background.
  /// The [child] parameter is the content widget to be displayed.
  const CardExpandableContent({
    super.key,
    required this.isExpanded,
    required this.padding,
    required this.lightGradient,
    required this.darkGradient,
    required this.child,
  });

  final bool isExpanded;
  final double padding;
  final LinearGradient lightGradient;
  final LinearGradient darkGradient;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // 🎬 Create an AnimationController to control the animation
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400), // Animation duration: 400ms
    );

    // 📏 Define a height factor animation using a curved animation
    final heightFactor = useAnimation(
      CurvedAnimation(
        parent: controller, // Uses the AnimationController as its parent
        curve: Curves.easeInOut, // Smooth in-out transition
      ),
    );

    // 🎭 Define a fade-in animation for opacity changes
    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(controller),
    );

    // 🔥 React to changes in `isExpanded` and trigger the animation accordingly
    useEffect(() {
      if (isExpanded) {
        controller.forward(); // Expand when `isExpanded` is true
      } else {
        controller.reverse(); // Collapse when `isExpanded` is false
      }
      return null; // No cleanup function needed
    }, [isExpanded]); // Only re-run when `isExpanded` changes

    return ClipRRect(
      // ✨ Round the bottom corners for a smooth card appearance
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: AnimatedBuilder(
        // 🎬 The builder automatically rebuilds whenever `controller` updates
        animation: controller,
        builder: (context, child) {
          return Align(
            heightFactor: heightFactor, // Dynamically adjusts height
            alignment: Alignment.topCenter, // Expands from the top
            child: AnimatedOpacity(
              opacity: fadeAnimation, // Applies the fade effect
              duration: const Duration(milliseconds: 300),
              child: child, // The expandable content
            ),
          );
        },
        child: Padding(
          // 📏 Dynamically adjust horizontal padding
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: BackdropFilter(
            // 🎨 Apply a subtle blur effect to the background
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity, // Expand width to fill available space
              padding: const EdgeInsets.all(20), // Inner padding
              decoration: BoxDecoration(
                // 🌗 Use different gradients based on light/dark mode
                gradient: isDarkMode ? darkGradient : lightGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: child, // The actual expandable content inside the card
            ),
          ),
        ),
      ),
    );
  }
}
