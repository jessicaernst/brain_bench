import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/presentation/auth/widgets/login_divider_view.dart';
import 'package:brain_bench/presentation/auth/widgets/social_login_button_view.dart';
import 'package:flutter/material.dart';

class LoginContentView extends StatelessWidget {
  const LoginContentView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isButtonEnabled,
    required this.onLoginPressed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isButtonEnabled;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
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
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(hintText: 'Email'),
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
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(hintText: 'Password'),
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
            isActive: isButtonEnabled,
            onPressed: onLoginPressed,
          ),
        ),
        const SizedBox(height: 32),
        const LoginDividerView(),
        const SizedBox(height: 24),
        const SocialLoginButtonView(),
      ],
    );
  }
}
