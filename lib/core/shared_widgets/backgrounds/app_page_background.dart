import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// A widget that displays a common background image for pages.
/// It adapts to dark and light mode.
class AppPageBackground extends StatelessWidget {
  const AppPageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox.expand(
      child:
          isDarkMode
              ? Assets.backgrounds.bgLoginSignUpDarkmode.image(
                fit: BoxFit.cover,
              )
              : Assets.backgrounds.signUp.image(fit: BoxFit.cover),
    );
  }
}
