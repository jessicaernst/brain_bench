import 'package:brain_bench/core/shared_widgets/buttons/darkmode_btn.dart';
import 'package:brain_bench/core/shared_widgets/buttons/lightmode_btn.dart';
import 'package:flutter/material.dart';

/// A switch button that toggles between light and dark mode.
///
/// This button displays a title and an active state indicator. When pressed,
/// it triggers the [onPressed] callback. The appearance of the button depends
/// on the current theme of the app.
class LightDarkSwitchBtn extends StatelessWidget {
  const LightDarkSwitchBtn({
    super.key,
    required this.title,
    required this.isActive,
    required this.onPressed,
    this.width,
  });

  final String title;
  final bool isActive;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return isDarkMode
        ? DarkmodeBtn(
          title: title,
          width: width,
          onPressed: isActive ? onPressed : () => debugPrint('Button inactive'),
          isActive: isActive,
        )
        : LightmodeBtn(
          title: title,
          width: width,
          onPressed: isActive ? onPressed : () => debugPrint('Button inactive'),
          isActive: isActive,
        );
  }
}
