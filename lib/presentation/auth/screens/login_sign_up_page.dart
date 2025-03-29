import 'package:brain_bench/core/hooks/animations.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_card_view.dart';
import 'package:brain_bench/presentation/auth/widgets/login_content_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class LoginSignUpPage extends HookConsumerWidget {
  const LoginSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideAnimation = useSlideInFromBottom();
    final fadeAnimation = useFadeIn();

    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isButtonEnabled = useState(false);

    useEffect(() {
      void validate() {
        isButtonEnabled.value = emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty;
      }

      emailController.addListener(validate);
      passwordController.addListener(validate);

      return () {
        emailController.removeListener(validate);
        passwordController.removeListener(validate);
      };
    }, [emailController, passwordController]);

    void onLoginPressed() {
      if (!isButtonEnabled.value) return;

      // TODO: Handle login logic here
      final email = emailController.text.trim();
      final password = passwordController.text;

      debugPrint('Logging in with $email / $password');
    }

    void onSignUpPressed() {
      // TODO: Handle sign-up logic here
      debugPrint('Sign Up pressed');
    }

    void onResetPasswordPressed() {
      // TODO: Handle reset password logic here
      debugPrint('Reset Password pressed');
    }

    void onGoogleLoginPressed() {
      // TODO: Handle Google login logic here
      debugPrint('Google Login pressed');
    }

    void onAppleLoginPressed() {
      // TODO: Handle Apple login logic here
      debugPrint('Apple Login pressed');
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: isKeyboardVisible
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 32,
                bottom:
                    isKeyboardVisible ? mediaQuery.viewInsets.bottom + 16 : 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  alignment: isKeyboardVisible
                      ? Alignment.topCenter
                      : Alignment.center,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: AuthCardView(
                        content: LoginContentView(
                          emailController: emailController,
                          passwordController: passwordController,
                          isButtonEnabled: isButtonEnabled.value,
                          onLoginPressed: onLoginPressed,
                          onSignUpPressed: onSignUpPressed,
                          onResetPasswordPressed: onResetPasswordPressed,
                          onGoogleLoginPressed: () {},
                          onAppleLoginPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
