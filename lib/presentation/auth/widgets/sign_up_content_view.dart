import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
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
    required this.repeatPasswordController,
    required this.isButtonEnabled,
    required this.onSignUpPressed,
    required this.onBackPressed,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;
  final bool isButtonEnabled;
  final VoidCallback onSignUpPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final showPassword = useState(false);
    final showRepeatPassword = useState(false);
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final repeatPasswordError = useState<String?>(null);

    // Create FocusNodes
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final repeatPasswordFocusNode = useFocusNode();

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.authRegisterTitle,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 24),
        AutofillGroup(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                focusNode: emailFocusNode,
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  // Changed here
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
                onSubmitted: (_) => passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscureText: !showPassword.value,
                enableSuggestions: false,
                autocorrect: false,
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  // Changed here
                  color: BrainBenchColors.deepDive,
                ),
                decoration: InputDecoration(
                  hintText: localizations.authPassword,
                  errorText: passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      size: 20,
                      color: BrainBenchColors.deepDive.withAlpha(
                        (0.6 * 255).toInt(),
                      ),
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
                textInputAction: TextInputAction.next,
                onChanged: (_) => passwordError.value = null,
                onSubmitted: (_) => repeatPasswordFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: repeatPasswordController,
                focusNode: repeatPasswordFocusNode,
                obscureText: !showRepeatPassword.value,
                enableSuggestions: false,
                autocorrect: false,
                style: TextTheme.of(
                  context,
                ).bodyMedium?.copyWith(color: BrainBenchColors.deepDive),
                decoration: InputDecoration(
                  hintText: localizations.authRepeatPassword,
                  errorText: repeatPasswordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      size: 20,
                      color: BrainBenchColors.deepDive.withAlpha(
                        (0.6 * 255).toInt(),
                      ),
                      showRepeatPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      showRepeatPassword.value = !showRepeatPassword.value;
                    },
                  ),
                ),
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onChanged: (_) => repeatPasswordError.value = null,
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
                onPressed: onBackPressed,
                child: Text.rich(
                  TextSpan(
                    text: localizations.authLoginText,
                    style: Theme.of(context).textTheme.titleMedium,
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
            onPressed: () {
              // Manual validation
              emailError.value = null;
              passwordError.value = null;
              repeatPasswordError.value = null;

              if (emailController.text.isEmpty) {
                emailError.value = localizations.authEmailEmptyError;
              } else if (!emailRegex.hasMatch(emailController.text)) {
                emailError.value = localizations.authEmailInvalidError;
              }

              if (passwordController.text.isEmpty) {
                passwordError.value = localizations.authPasswordEmptyError;
              } else if (passwordController.text.length < 6) {
                passwordError.value = localizations.authPasswordShortError;
              }

              if (repeatPasswordController.text.isEmpty) {
                repeatPasswordError.value =
                    localizations.authPasswordEmptyError;
              } else if (repeatPasswordController.text !=
                  passwordController.text) {
                repeatPasswordError.value =
                    localizations.authPasswordNotMatchError;
              }

              if (emailError.value == null &&
                  passwordError.value == null &&
                  repeatPasswordError.value == null) {
                onSignUpPressed();
              }
            },
          ),
        ),
        const SizedBox(height: 32),
        LoginDividerView(title: localizations.authDividerRegisterText),
        const SizedBox(height: 24),
        SocialLoginButtonView(
          onGoogleLoginPressed: onGoogleLoginPressed,
          onAppleLoginPressed: onAppleLoginPressed,
        ),
      ],
    );
  }
}
