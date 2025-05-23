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
    // Watch the AuthViewModel state for loading and error states
    final authState = ref.watch(authViewModelProvider);
    final bool isLoading = authState.isLoading;

    void handleLogin() {
      if (!isButtonEnabled) return;
      authNotifier.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }

    void handleSignUp() {
      if (!isButtonEnabled) return;
      authNotifier.signUp(
        email: emailSignUpController.text.trim(),
        password: passwordSignUpController.text,
      );
    }

    void switchToSignUp() {
      emailController.clear();
      passwordController.clear();
      isLogin.value = false;
    }

    void switchToLogin() {
      emailSignUpController.clear();
      passwordSignUpController.clear();
      repeatPasswordSignUpController.clear();
      isLogin.value = true;
    }

    void handlePasswordReset() {
      if (emailController.text.trim().isNotEmpty) {
        authNotifier.sendPasswordResetEmail(email: emailController.text.trim());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.authPasswordResetEmailPrompt)),
        );
      }
    }

    void handleGoogleLogin() => authNotifier.signInWithGoogle();
    void handleAppleLogin() => authNotifier.signInWithApple();

    // Listen for errors from AuthViewModel to show a SnackBar
    ref.listen<AsyncValue<void>>(authViewModelProvider, (_, state) {
      if (state is AsyncError) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.authErrorGeneric(state.error.toString()),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    });
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
          // Modal Loading Indicator
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(
                  (0.5 * 255).toInt(),
                ), // Semi-transparent overlay
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        Text(
                          localizations.authLoadingText,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
