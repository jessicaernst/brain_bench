import 'dart:ui';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/presentation/auth/widgets/social_image_button.dart';
import 'package:flutter/material.dart';

class LoginCardView extends StatelessWidget {
  const LoginCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Stack(
          children: [
            // 1. Shadow-Ebene mit weißer Hintergrundschicht
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: BrainBenchColors.cloudCanvas
                      .withAlpha((0.7 * 255).toInt()),
                  boxShadow: _shadows,
                ),
              ),
            ),
            // 2. Obere Glass/Gradient-Schicht mit Blur
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        BrainBenchColors.blueprintBlue
                            .withAlpha((0.4 * 255).toInt()),
                        BrainBenchColors.blueprintBlue
                            .withAlpha((0.1 * 255).toInt()),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withAlpha((0.7 * 255).toInt()),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextTheme.of(context).displayLarge,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextTheme.of(context).titleMedium,
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up here',
                                      style: TextTheme.of(context).titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text.rich(
                                TextSpan(
                                  text: 'Forgot your password? ',
                                  style: TextTheme.of(context).titleMedium,
                                  children: [
                                    TextSpan(
                                      text: 'Reset here',
                                      style: TextTheme.of(context).titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: LightDarkSwitchBtn(
                            title: 'Login',
                            width: double.infinity,
                            isActive: false,
                            onPressed: () {}),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color.fromRGBO(60, 60, 67, 0.29),
                              thickness: 0.7,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Or Login with',
                            style: TextTheme.of(context).bodySmall,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Divider(
                              color: Color.fromRGBO(60, 60, 67, 0.29),
                              thickness: 0.7,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialImageButton(
                            imagePath: Assets.socialLogins.googleLogo.path,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 48),
                          SocialImageButton(
                            imagePath:
                                Assets.socialLogins.appleidButtonBlack.path,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<BoxShadow> _shadows = [
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.10 * 255).toInt()),
      blurRadius: 15,
      offset: const Offset(0, 7)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.09 * 255).toInt()),
      blurRadius: 27,
      offset: const Offset(0, 27)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.05 * 255).toInt()),
      blurRadius: 36,
      offset: const Offset(0, 60)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.01 * 255).toInt()),
      blurRadius: 43,
      offset: const Offset(0, 107)),
  BoxShadow(
      color: BrainBenchColors.deepDive.withAlpha((0.00 * 255).toInt()),
      blurRadius: 47,
      offset: const Offset(0, 167)),
];
