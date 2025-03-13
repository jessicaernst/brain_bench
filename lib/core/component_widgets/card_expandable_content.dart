import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardExpandableContent extends HookConsumerWidget {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎬 Animation Controller mit `useAnimationController()`
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    final heightFactor = useAnimation(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    final fadeAnimation =
        useAnimation(Tween<double>(begin: 0, end: 1).animate(controller));

    useEffect(() {
      if (isExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, [isExpanded]);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Align(
            heightFactor: heightFactor,
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: fadeAnimation,
              duration: const Duration(milliseconds: 300),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isDarkMode ? darkGradient : lightGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
