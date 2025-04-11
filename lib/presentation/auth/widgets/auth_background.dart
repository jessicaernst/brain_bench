import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Stack(
      children: [
        // Background image filling the screen
        Positioned.fill(
          child: isDarkMode
              ? Assets.backgrounds.bgLoginSignUpDarkmode.image()
              : Assets.backgrounds.signUp.image(
                  fit: BoxFit.cover, // Cover the entire area
                ),
        ),
        // Positioned Dash logo (adjust positioning as needed)
        Positioned(
          top: -40, // Example positioning
          child: Assets.images.dashLogo.image(
            width: 545,
            height: 500,
          ),
        ),
      ],
    );
  }
}
