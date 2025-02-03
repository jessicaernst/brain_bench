import 'package:brain_bench/core/widgets/darkmode_btn.dart';
import 'package:brain_bench/core/widgets/lightmode_btn.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.title,
    required this.isActive,
    required this.isDarkMode,
    required this.onPressed,
  });

  final String title;
  final bool isActive;
  final bool isDarkMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return isDarkMode
        ? LightmodeBtn(
            title: title,
            onPressed:
                isActive ? onPressed : () => debugPrint('Button inactive'),
            isActive: isActive,
          )
        : DarkmodeBtn(
            title: title,
            onPressed:
                isActive ? onPressed : () => debugPrint('Button inactive'),
            isActive: isActive,
          );
  }
}
