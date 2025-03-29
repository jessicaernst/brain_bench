import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Hook that provides a SlideTransition + optional FadeTransition from bottom.
/// Can be customized via [duration], [curve], and [fade].
///
/// Example usage:
/// ```dart
/// final animation = useSlideInFromBottom();
/// SlideTransition(
///   position: animation,
///   child: YourWidget(),
/// )
/// ```
Animation<Offset> useSlideInFromBottom({
  Duration duration = const Duration(milliseconds: 1200),
  Curve curve = Curves.easeOutCubic,
}) {
  final controller = useAnimationController(duration: duration)..forward();

  final animation = useMemoized(() {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }, [controller]);

  return animation;
}

/// Optional fade-in hook
Animation<double> useFadeIn({
  Duration duration = const Duration(milliseconds: 1200),
  Curve curve = Curves.easeOutCubic,
}) {
  final controller = useAnimationController(duration: duration)..forward();

  final animation = useMemoized(() {
    return CurvedAnimation(parent: controller, curve: curve);
  }, [controller]);

  return animation;
}
