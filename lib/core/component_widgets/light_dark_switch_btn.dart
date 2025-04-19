import 'package:brain_bench/core/component_widgets/darkmode_btn.dart';
import 'package:brain_bench/core/component_widgets/lightmode_btn.dart';
import 'package:flutter/material.dart';

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
            onPressed:
                isActive ? onPressed : () => debugPrint('Button inactive'),
            isActive: isActive,
          )
        : LightmodeBtn(
            title: title,
            width: width,
            onPressed:
                isActive ? onPressed : () => debugPrint('Button inactive'),
            isActive: isActive,
          );
  }
}
