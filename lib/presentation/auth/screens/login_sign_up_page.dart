import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/core/hooks/animations.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_background.dart';
import 'package:brain_bench/presentation/auth/widgets/auth_content.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

// Main Widget: LoginSignUpPage
class LoginSignUpPage extends HookConsumerWidget {
  const LoginSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks for State and Controllers ---
    // State for toggling between Login and SignUp views
    final isLogin = useState(true);
    final previousIsLogin = usePrevious(isLogin.value);
    // Used for the AnimatedSwitcher transition direction
    final isSwitchingToLogin =
        previousIsLogin == false && isLogin.value == true;

    // Text Editing Controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailSignUpController = useTextEditingController();
    final passwordSignUpController = useTextEditingController();
    final repeatPasswordSignUpController = useTextEditingController();

    // State for enabling/disabling the main action button
    final isButtonEnabled = useState(false);

    // Animation Hooks
    final slideAnimation = useSlideInFromBottom(); // For initial page slide-in
    final fadeAnimation = useFadeIn(); // For initial page fade-in

    // Access the AuthViewModel Notifier
    final authNotifier = ref.read(authViewModelProvider.notifier);

    // --- Logic and Callbacks ---

    // Validation logic encapsulated in useEffect
    useEffect(() {
      void validate() {
        // Check if fields for the current view (Login or SignUp) are filled
        final isLoginFieldsFilled = emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty;
        final isSignUpFieldsFilled = emailSignUpController.text.isNotEmpty &&
            passwordSignUpController.text.isNotEmpty &&
            repeatPasswordSignUpController.text.isNotEmpty;
        // Update the button enabled state based on the current view
        isButtonEnabled.value =
            isLogin.value ? isLoginFieldsFilled : isSignUpFieldsFilled;
      }

      // Add listeners to all relevant controllers
      emailController.addListener(validate);
      passwordController.addListener(validate);
      emailSignUpController.addListener(validate);
      passwordSignUpController.addListener(validate);
      repeatPasswordSignUpController.addListener(validate);

      // Perform initial validation
      validate();

      // Cleanup: Remove listeners when the widget disposes or dependencies change
      return () {
        emailController.removeListener(validate);
        passwordController.removeListener(validate);
        emailSignUpController.removeListener(validate);
        passwordSignUpController.removeListener(validate);
        repeatPasswordSignUpController.removeListener(validate);
      };
      // Dependencies: Re-run effect if any controller or the isLogin state changes
    }, [
      emailController,
      passwordController,
      emailSignUpController,
      passwordSignUpController,
      repeatPasswordSignUpController,
      isLogin.value // Crucial to re-validate when switching views
    ]);

    // --- Callback Functions ---
    // Clearly named functions for actions
    void handleLogin() {
      if (!isButtonEnabled.value) {
        return; // Prevent action if button is disabled
      }
      authNotifier.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
        context: context,
      );
    }

    void handleSignUp() {
      if (!isButtonEnabled.value) {
        return; // Prevent action if button is disabled
      }
      authNotifier.signUp(
        email: emailSignUpController.text.trim(),
        password: passwordSignUpController.text,
        context: context,
      );
    }

    void switchToSignUp() {
      emailController.clear(); // Clear login fields
      passwordController.clear();
      isLogin.value = false; // Switch state
      // isButtonEnabled will be re-validated by the useEffect hook
    }

    void switchToLogin() {
      emailSignUpController.clear(); // Clear sign-up fields
      passwordSignUpController.clear();
      repeatPasswordSignUpController.clear();
      isLogin.value = true; // Switch state
      // isButtonEnabled will be re-validated by the useEffect hook
    }

    void handlePasswordReset() {
      // Only proceed if the email field in the login form is not empty
      if (emailController.text.trim().isNotEmpty) {
        authNotifier.sendPasswordResetEmail(
          email: emailController.text.trim(),
          context: context,
        );
      } else {
        // Optional: Show a message if the email field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email first.')),
        );
      }
    }

    void handleGoogleLogin() => authNotifier.signInWithGoogle(context);
    void handleAppleLogin() => authNotifier.signInWithApple(context);

    // --- UI Build ---
    // The build method is now much cleaner, focusing on structure
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjusts view when keyboard appears
      body: Stack(
        children: [
          const AuthBackground(),
          AuthContent(
            // Pass state and controllers
            isLogin: isLogin.value,
            isSwitchingToLogin: isSwitchingToLogin,
            emailController: emailController,
            passwordController: passwordController,
            emailSignUpController: emailSignUpController,
            passwordSignUpController: passwordSignUpController,
            repeatPasswordSignUpController: repeatPasswordSignUpController,
            isButtonEnabled: isButtonEnabled.value,
            // Pass animations
            slideAnimation: slideAnimation,
            fadeAnimation: fadeAnimation,
            // Pass callbacks
            onLoginPressed: handleLogin,
            onSignUpPressed: handleSignUp,
            onSwitchToSignUpPressed: switchToSignUp,
            onSwitchToLoginPressed: switchToLogin,
            onResetPasswordPressed: handlePasswordReset,
            onGoogleLoginPressed: handleGoogleLogin,
            onAppleLoginPressed: handleAppleLogin,
          ),
        ],
      ),
    );
  }
}
