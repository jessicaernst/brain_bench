import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/presentation/auth/widgets/login_divider_view.dart';
import 'package:brain_bench/presentation/auth/widgets/social_login_button_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginContentView extends HookWidget {
  const LoginContentView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isButtonEnabled,
    required this.onLoginPressed,
    required this.onSignUpPressed,
    required this.onResetPasswordPressed,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isButtonEnabled;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;
  final VoidCallback onResetPasswordPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final showPassword = useState(false);
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.authLoginTitle,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 24),
        AutofillGroup(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: BrainBenchColors.deepDive,
                    ),
                decoration: InputDecoration(
                  hintText: localizations.authEmail,
                  errorText: emailError.value,
                ),
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_) => emailError.value = null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !showPassword.value,
                enableSuggestions: false,
                autocorrect: false,
                style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: BrainBenchColors.deepDive,
                    ),
                decoration: InputDecoration(
                  hintText: localizations.authPassword,
                  errorText: passwordError.value,
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
                onChanged: (_) => passwordError.value = null,
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
                onPressed: onSignUpPressed,
                child: Text.rich(
                  TextSpan(
                    text: localizations.authSignUpText,
                    style: TextTheme.of(context).titleMedium,
                    children: [
                      TextSpan(
                        text: localizations.authSignUpTextBtnLbl,
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: onResetPasswordPressed,
                child: Text.rich(
                  TextSpan(
                    text: localizations.authPwdForgottenText,
                    style: TextTheme.of(context).titleMedium,
                    children: [
                      TextSpan(
                        text: localizations.authPwdForgottenBtnLbl,
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
            title: localizations.authLoginBtnLbl,
            width: double.infinity,
            isActive: isButtonEnabled,
            onPressed: () {
              // Manual validation
              emailError.value = null;
              passwordError.value = null;

              if (emailController.text.isEmpty) {
                emailError.value = localizations.authEmailEmptyError;
              } else if (!emailController.text.contains('@')) {
                emailError.value = localizations.authEmailInvalidError;
              }

              if (passwordController.text.isEmpty) {
                passwordError.value = localizations.authPasswordEmptyError;
              } else if (passwordController.text.length < 6) {
                passwordError.value = localizations.authPasswordShortError;
              }

              if (emailError.value == null && passwordError.value == null) {
                onLoginPressed();
              }
            },
          ),
        ),
        const SizedBox(height: 32),
        LoginDividerView(
          title: localizations.authDividerLoginText,
        ),
        const SizedBox(height: 24),
        SocialLoginButtonView(
          onGoogleLoginPressed: onGoogleLoginPressed,
          onAppleLoginPressed: onAppleLoginPressed,
        ),
      ],
    );
  }
}
