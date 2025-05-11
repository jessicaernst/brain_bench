import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPageBackground extends StatelessWidget {
  const ProfileSettingsPageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final screenSize = context.screenSize;
    final screenWidth = screenSize.width;
    final bool isSmallScreenValue = context.isSmallScreen;
    final double logoWidth = isSmallScreenValue ? 420 : 565;
    final double logoHeight = isSmallScreenValue ? 360 : 480;
    final double topPosition = isSmallScreenValue ? 20 : 30;
    final double horizontalOffset = isSmallScreenValue ? 90 : 75;

    return Stack(
      children: [
        Positioned.fill(
          child:
              isDarkMode
                  ? Assets.backgrounds.bgLoginSignUpDarkmode.image(
                    fit: BoxFit.cover,
                  )
                  : Assets.backgrounds.signUp.image(fit: BoxFit.cover),
        ),
        Positioned(
          top: topPosition,
          left: (screenWidth - logoWidth) / 2 + horizontalOffset,
          child: Assets.images.dashLogo.image(
            width: logoWidth,
            height: logoHeight,
          ),
        ),
      ],
    );
  }
}
