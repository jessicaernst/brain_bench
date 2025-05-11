import 'dart:io';

import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/presentation/auth/widgets/social_image_button.dart';
import 'package:flutter/material.dart';

class SocialLoginButtonView extends StatelessWidget {
  const SocialLoginButtonView({
    super.key,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  });

  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 48,
      children: [
        SocialImageButton(
          imagePath: Assets.socialLogins.googleLogo.path,
          onPressed: onGoogleLoginPressed,
        ),
        if (Platform.isIOS)
          SocialImageButton(
            imagePath:
                isDarkMode
                    ? Assets.socialLogins.appleidButtonWhite.path
                    : Assets.socialLogins.appleidButtonBlack.path,
            onPressed: onAppleLoginPressed,
          ),
      ],
    );
  }
}
