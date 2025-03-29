import 'package:brain_bench/core/hooks/animations.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_card_view.dart';
import 'package:brain_bench/presentation/auth/widgets/login_content_view.dart';
import 'package:brain_bench/presentation/auth/widgets/sign_up_content_view.dart';
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
    final emailSignUpController = useTextEditingController();
    final passwordSignUpController = useTextEditingController();
    final isButtonEnabled = useState(false);
    final isLogin = useState(true);
    final previousIsLogin = usePrevious(isLogin.value);
    final isSwitchingToLogin =
        previousIsLogin == false && isLogin.value == true;

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

      final email = emailController.text.trim();
      final password = passwordController.text;

      debugPrint('Logging in with $email / $password');
    }

    void onSignUpPressed() {
      isLogin.value = false;
    }

    void onBackToLoginPressed() {
      isLogin.value = true;
    }

    void onResetPasswordPressed() {
      debugPrint('Reset Password pressed');
    }

    void onGoogleLoginPressed() {
      debugPrint('Google Login pressed');
    }

    void onAppleLoginPressed() {
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: Offset(isSwitchingToLogin ? -1 : 1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ));

                          final fade = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );

                          return SlideTransition(
                            position: offsetAnimation,
                            child: FadeTransition(
                              opacity: fade,
                              child: child,
                            ),
                          );
                        },
                        child: isLogin.value
                            ? AuthCardView(
                                key: const ValueKey('login'),
                                content: LoginContentView(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  isButtonEnabled: isButtonEnabled.value,
                                  onLoginPressed: onLoginPressed,
                                  onSignUpPressed: onSignUpPressed,
                                  onResetPasswordPressed:
                                      onResetPasswordPressed,
                                  onGoogleLoginPressed: onGoogleLoginPressed,
                                  onAppleLoginPressed: onAppleLoginPressed,
                                ),
                              )
                            : AuthCardView(
                                key: const ValueKey('signup'),
                                content: SignUpContentView(
                                  emailController: emailSignUpController,
                                  passwordController: passwordSignUpController,
                                  isButtonEnabled: isButtonEnabled.value,
                                  onBackPressed: onBackToLoginPressed,
                                  onLoginPressed: onLoginPressed,
                                  onSignUpPressed: onSignUpPressed,
                                  onGoogleLoginPressed: onGoogleLoginPressed,
                                  onAppleLoginPressed: onAppleLoginPressed,
                                ),
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
