import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPageBackground extends StatelessWidget {
  const ProfileSettingsPageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: isDarkMode
              ? Assets.backgrounds.bgLoginSignUpDarkmode
                  .image(fit: BoxFit.cover)
              : Assets.backgrounds.signUp.image(
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 30,
          child: Assets.images.dashLogo.image(
            width: 565,
            height: 480,
          ),
        ),
      ],
    );
  }
}
