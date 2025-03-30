import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/core/hooks/animations.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_card_view.dart';
import 'package:brain_bench/presentation/auth/widgets/login_content_view.dart';
import 'package:brain_bench/presentation/auth/widgets/sign_up_content_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:brain_bench/gen/assets.gen.dart';

class LoginSignUpPage extends HookConsumerWidget {
  const LoginSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final slideAnimation = useSlideInFromBottom();
    final fadeAnimation = useFadeIn();

    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailSignUpController = useTextEditingController();
    final passwordSignUpController = useTextEditingController();
    final repeatPasswordSignUpController = useTextEditingController();

    final isButtonEnabled = useState(false);
    final isLogin = useState(true);
    final previousIsLogin = usePrevious(isLogin.value);
    final isSwitchingToLogin =
        previousIsLogin == false && isLogin.value == true;
    final authNotifier = ref.read(authViewModelProvider.notifier);

    void validate() {
      // Check for Login fields
      final isLoginFieldsFilled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

      // Check for SignUp fields
      final isSignUpFieldsFilled = emailSignUpController.text.isNotEmpty &&
          passwordSignUpController.text.isNotEmpty &&
          repeatPasswordSignUpController.text.isNotEmpty;

      // Update isButtonEnabled based on the current view
      isButtonEnabled.value =
          isLogin.value ? isLoginFieldsFilled : isSignUpFieldsFilled;
    }

    useEffect(() {
      // Listen to all controllers
      emailController.addListener(validate);
      passwordController.addListener(validate);
      emailSignUpController.addListener(validate);
      passwordSignUpController.addListener(validate);
      repeatPasswordSignUpController.addListener(validate);

      return () {
        // Remove all listeners
        emailController.removeListener(validate);
        passwordController.removeListener(validate);
        emailSignUpController.removeListener(validate);
        passwordSignUpController.removeListener(validate);
        repeatPasswordSignUpController.removeListener(validate);
      };
    }, [
      emailController,
      passwordController,
      emailSignUpController,
      passwordSignUpController,
      repeatPasswordSignUpController
    ]);

    void onLoginPressed() {
      if (!isButtonEnabled.value) return;
      authNotifier.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
        context: context,
      );
    }

    void onSignUpPressed() {
      if (!isButtonEnabled.value) return;
      authNotifier.signUp(
        email: emailSignUpController.text.trim(),
        password: passwordSignUpController.text,
        context: context,
      );
    }

    void onLoginTxtBtnPressed() {
      emailController.clear();
      passwordController.clear();
      isLogin.value = false;
    }

    void onBackPressed() {
      emailSignUpController.clear();
      passwordSignUpController.clear();
      repeatPasswordSignUpController.clear();
      isLogin.value = true;
      validate();
    }

    void onResetPasswordPressed() {
      authNotifier.sendPasswordResetEmail(
        email: emailController.text.trim(),
        context: context,
      );
    }

    void onGoogleLoginPressed() {
      authNotifier.signInWithGoogle(context);
    }

    void onAppleLoginPressed() {
      authNotifier.signInWithApple(context);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: isDarkMode
                ? Assets.backgrounds.bgLoginSignUpDarkmode.image()
                : Assets.backgrounds.signUp.image(
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: -40,
            child: Assets.images.dashLogo.image(
              width: 545,
              height: 500,
            ),
          ),
          SafeArea(
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
                    bottom: isKeyboardVisible
                        ? mediaQuery.viewInsets.bottom + 16
                        : 32,
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
                                      onSignUpPressed: onLoginTxtBtnPressed,
                                      onResetPasswordPressed:
                                          onResetPasswordPressed,
                                      onGoogleLoginPressed:
                                          onGoogleLoginPressed,
                                      onAppleLoginPressed: onAppleLoginPressed,
                                    ),
                                  )
                                : AuthCardView(
                                    key: const ValueKey('signup'),
                                    content: SignUpContentView(
                                      emailController: emailSignUpController,
                                      passwordController:
                                          passwordSignUpController,
                                      repeatPasswordController:
                                          repeatPasswordSignUpController,
                                      isButtonEnabled: isButtonEnabled.value,
                                      onBackPressed: onBackPressed,
                                      onSignUpPressed: onSignUpPressed,
                                      onGoogleLoginPressed:
                                          onGoogleLoginPressed,
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
        ],
      ),
    );
  }
}
