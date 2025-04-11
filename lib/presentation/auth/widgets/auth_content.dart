import 'package:brain_bench/presentation/auth/widgets/auth_card_view.dart';
import 'package:brain_bench/presentation/auth/widgets/login_content_view.dart';
import 'package:brain_bench/presentation/auth/widgets/sign_up_content_view.dart';
import 'package:flutter/material.dart';

class AuthContent extends StatelessWidget {
  // Define required parameters for state, controllers, animations, and callbacks
  final bool isLogin;
  final bool isSwitchingToLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController emailSignUpController;
  final TextEditingController passwordSignUpController;
  final TextEditingController repeatPasswordSignUpController;
  final bool isButtonEnabled;
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;
  final VoidCallback onSwitchToSignUpPressed;
  final VoidCallback onSwitchToLoginPressed;
  final VoidCallback onResetPasswordPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  const AuthContent({
    super.key,
    required this.isLogin,
    required this.isSwitchingToLogin,
    required this.emailController,
    required this.passwordController,
    required this.emailSignUpController,
    required this.passwordSignUpController,
    required this.repeatPasswordSignUpController,
    required this.isButtonEnabled,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onLoginPressed,
    required this.onSignUpPressed,
    required this.onSwitchToSignUpPressed,
    required this.onSwitchToLoginPressed,
    required this.onResetPasswordPressed,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Check if the keyboard is visible by inspecting bottom view insets
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use SingleChildScrollView to prevent overflow when keyboard appears
          return SingleChildScrollView(
            // Adjust scroll physics based on keyboard visibility
            physics: isKeyboardVisible
                ? const ClampingScrollPhysics() // Allow scrolling if needed
                : const NeverScrollableScrollPhysics(), // Disable scrolling otherwise
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 32, // Fixed top padding
              // Dynamic bottom padding based on keyboard visibility
              bottom: isKeyboardVisible
                  ? mediaQuery.viewInsets.bottom +
                      16 // Space for keyboard + buffer
                  : 32, // Fixed bottom padding otherwise
            ),
            // Ensure the content area tries to fill the available height
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Calculate minimum height considering keyboard and padding
                minHeight: constraints.maxHeight -
                    (isKeyboardVisible ? mediaQuery.viewInsets.bottom : 0) -
                    64, // Adjusted height (top+bottom padding)
              ),
              // Animate the alignment based on keyboard status
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                // Center when keyboard is hidden, align top when visible
                alignment:
                    isKeyboardVisible ? Alignment.topCenter : Alignment.center,
                // Apply initial entrance animations (Slide + Fade)
                child: SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    // AnimatedSwitcher handles the transition between Login and SignUp views
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      // Define the transition animation between children
                      transitionBuilder: (child, animation) {
                        // Slide animation for the switch
                        final offsetAnimation = Tween<Offset>(
                          // Direction depends on whether switching to Login or SignUp
                          begin: Offset(isSwitchingToLogin ? -1.0 : 1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic, // Smooth transition curve
                        ));
                        // Fade animation for the switch
                        final fade = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut, // Gentle fade in/out
                        );

                        // Combine Slide and Fade transitions
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: fade,
                            child: child, // The incoming child widget
                          ),
                        );
                      },
                      // The child widget to display, based on the `isLogin` state
                      child: isLogin
                          ? AuthCardView(
                              // Unique key for AnimatedSwitcher to identify the child
                              key: const ValueKey('login'),
                              content: LoginContentView(
                                emailController: emailController,
                                passwordController: passwordController,
                                isButtonEnabled: isButtonEnabled,
                                onLoginPressed: onLoginPressed,
                                // Pass the callback to switch *to* SignUp
                                onSignUpPressed: onSwitchToSignUpPressed,
                                onResetPasswordPressed: onResetPasswordPressed,
                                onGoogleLoginPressed: onGoogleLoginPressed,
                                onAppleLoginPressed: onAppleLoginPressed,
                              ),
                            )
                          : AuthCardView(
                              // Unique key for AnimatedSwitcher
                              key: const ValueKey('signup'),
                              content: SignUpContentView(
                                emailController: emailSignUpController,
                                passwordController: passwordSignUpController,
                                repeatPasswordController:
                                    repeatPasswordSignUpController,
                                isButtonEnabled: isButtonEnabled,
                                // Pass the callback to switch *back* to Login
                                onBackPressed: onSwitchToLoginPressed,
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
    );
  }
}
