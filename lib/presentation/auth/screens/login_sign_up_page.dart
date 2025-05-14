import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/core/hooks/animations.dart';
import 'package:brain_bench/core/hooks/auth.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_background.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Main Widget: LoginSignUpPage
class LoginSignUpPage extends HookConsumerWidget {
  LoginSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final isLogin = useState(true);
    final previousIsLogin = usePrevious(isLogin.value);
    final isSwitchingToLogin =
        previousIsLogin == false && isLogin.value == true;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailSignUpController = useTextEditingController();
    final passwordSignUpController = useTextEditingController();
    final repeatPasswordSignUpController = useTextEditingController();

    final bool isButtonEnabled = useAuthValidation(
      isLoginModeNotifier: isLogin,
      loginEmailController: emailController,
      loginPasswordController: passwordController,
      signUpEmailController: emailSignUpController,
      signUpPasswordController: passwordSignUpController,
      signUpRepeatPasswordController: repeatPasswordSignUpController,
    );

    // Animation Hooks
    final slideAnimation = useSlideInFromBottom();
    final fadeAnimation = useFadeIn();

    // Access the AuthViewModel Notifier
    final authNotifier = ref.read(authViewModelProvider.notifier);

    void handleLogin() {
      if (!isButtonEnabled) return;
      authNotifier.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
        context: context,
      );
    }

    void handleSignUp() {
      if (!isButtonEnabled) return;
      authNotifier.signUp(
        email: emailSignUpController.text.trim(),
        password: passwordSignUpController.text,
        context: context,
      );
    }

    void switchToSignUp() {
      emailController.clear();
      passwordController.clear();
      isLogin.value = false; // Hook will react to this change
    }

    void switchToLogin() {
      emailSignUpController.clear();
      passwordSignUpController.clear();
      repeatPasswordSignUpController.clear();
      isLogin.value = true; // Hook will react to this change
    }

    void handlePasswordReset() {
      if (emailController.text.trim().isNotEmpty) {
        authNotifier.sendPasswordResetEmail(
          email: emailController.text.trim(),
          context: context,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.authPasswordResetEmailPrompt)),
        );
      }
    }

    void handleGoogleLogin() => authNotifier.signInWithGoogle(context);
    void handleAppleLogin() => authNotifier.signInWithApple(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const AuthBackground(),
          SafeArea(
            child: AuthContent(
              isLogin: isLogin.value,
              isSwitchingToLogin: isSwitchingToLogin,
              emailController: emailController,
              passwordController: passwordController,
              emailSignUpController: emailSignUpController,
              passwordSignUpController: passwordSignUpController,
              repeatPasswordSignUpController: repeatPasswordSignUpController,
              isButtonEnabled: isButtonEnabled,
              slideAnimation: slideAnimation,
              fadeAnimation: fadeAnimation,
              onLoginPressed: handleLogin,
              onSignUpPressed: handleSignUp,
              onSwitchToSignUpPressed: switchToSignUp,
              onSwitchToLoginPressed: switchToLogin,
              onResetPasswordPressed: handlePasswordReset,
              onGoogleLoginPressed: handleGoogleLogin,
              onAppleLoginPressed: handleAppleLogin,
            ),
          ),
        ],
      ),
    );
  }
}
