import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/auth/widgets/login_divider_view.dart';
import 'package:brain_bench/presentation/auth/widgets/social_login_button_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpContentView extends HookWidget {
  const SignUpContentView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isButtonEnabled,
    required this.onLoginPressed,
    required this.onSignUpPressed,
    required this.onBackPressed,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isButtonEnabled;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final showPassword = useState(false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.authRegisterTitle,
          style: TextTheme.of(context).displayLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 24),
        AutofillGroup(
          child: Column(
            children: [
              SizedBox(
                height: 36,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrainBenchColors.deepDive,
                      ),
                  decoration:
                      InputDecoration(hintText: localizations.authEmail),
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: TextField(
                  controller: passwordController,
                  obscureText: !showPassword.value,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrainBenchColors.deepDive,
                      ),
                  decoration: InputDecoration(
                    hintText: localizations.authPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 20,
                        color: BrainBenchColors.deepDive
                            .withAlpha((0.6 * 255).toInt()),
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        showPassword.value = !showPassword.value;
                      },
                    ),
                  ),
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: TextField(
                  controller: passwordController,
                  obscureText: !showPassword.value,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrainBenchColors.deepDive,
                      ),
                  decoration: InputDecoration(
                    hintText: localizations.authRepeatPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 20,
                        color: BrainBenchColors.deepDive
                            .withAlpha((0.6 * 255).toInt()),
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        showPassword.value = !showPassword.value;
                      },
                    ),
                  ),
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onBackPressed, // Call the callback
                child: Text.rich(
                  TextSpan(
                    text: localizations.authLoginText,
                    style: TextTheme.of(context).titleMedium,
                    children: [
                      TextSpan(
                        text: localizations.authLoginTextBtnLbl,
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
            title: localizations.authRegisterBtnLbl,
            width: double.infinity,
            isActive: isButtonEnabled,
            onPressed: onLoginPressed,
          ),
        ),
        const SizedBox(height: 32),
        LoginDividerView(
          title: localizations.authDividerRegisterText,
        ), // Remove title parameter
        const SizedBox(height: 24),
        SocialLoginButtonView(
          onGoogleLoginPressed: onGoogleLoginPressed,
          onAppleLoginPressed: onAppleLoginPressed,
        ),
      ],
    );
  }
}
