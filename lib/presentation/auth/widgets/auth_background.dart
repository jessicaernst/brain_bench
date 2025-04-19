import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Background image filling the screen
        Positioned.fill(
          child: isDarkMode
              ? Assets.backgrounds.bgLoginSignUpDarkmode.image()
              : Assets.backgrounds.signUp.image(
                  fit: BoxFit.cover,
                ),
        ),
        // Positioned Dash logo
        Positioned(
          top: -55, // Example positioning
          child: Assets.images.dashLogo.image(
            width: 545,
            height: 500,
          ),
        ),
      ],
    );
  }
}
