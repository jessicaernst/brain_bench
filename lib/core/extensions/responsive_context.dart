import 'package:flutter/widgets.dart';

/// Extension methods for [BuildContext] to provide responsive helpers.
extension ResponsiveContext on BuildContext {
  /// Threshold height in logical pixels to determine if a screen is considered small.
  static const double _smallScreenThreshold = 700.0;

  /// Returns `true` if the screen height is less than [_smallScreenThreshold].
  bool get isSmallScreen {
    return MediaQuery.of(this).size.height < _smallScreenThreshold;
  }

  /// Returns the [Size] of the current media query.
  Size get screenSize => MediaQuery.of(this).size;
}
