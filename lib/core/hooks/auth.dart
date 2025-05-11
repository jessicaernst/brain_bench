import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom hook to manage button enabled state based on auth form field completion.
///
/// Listens to relevant controllers and the login/signup mode to determine
/// if the primary action button should be enabled.
bool useAuthValidation({
  required ValueNotifier<bool> isLoginModeNotifier,
  required TextEditingController loginEmailController,
  required TextEditingController loginPasswordController,
  required TextEditingController signUpEmailController,
  required TextEditingController signUpPasswordController,
  required TextEditingController signUpRepeatPasswordController,
}) {
  // Internal state for the hook to manage the enabled status
  final isEnabled = useState(false);

  // Effect to handle validation logic and listener management
  useEffect(
    () {
      // The validation function itself
      void validate() {
        final isLogin = isLoginModeNotifier.value; // Get current mode
        final bool fieldsFilled;
        if (isLogin) {
          fieldsFilled =
              loginEmailController.text.isNotEmpty &&
              loginPasswordController.text.isNotEmpty;
        } else {
          fieldsFilled =
              signUpEmailController.text.isNotEmpty &&
              signUpPasswordController.text.isNotEmpty &&
              signUpRepeatPasswordController.text.isNotEmpty;
        }
        // Update the hook's internal state
        isEnabled.value = fieldsFilled;
      }

      // Create a list of listeners to manage adding/removing them easily
      final controllers = [
        loginEmailController,
        loginPasswordController,
        signUpEmailController,
        signUpPasswordController,
        signUpRepeatPasswordController,
      ];

      // Add listeners
      isLoginModeNotifier.addListener(validate); // Listen to mode changes
      for (var controller in controllers) {
        controller.addListener(validate);
      }

      // Perform initial validation
      validate();

      // Cleanup function: Remove all listeners when the hook disposes
      return () {
        isLoginModeNotifier.removeListener(validate);
        for (var controller in controllers) {
          controller.removeListener(validate);
        }
      };
      // Dependencies: Rerun effect if any controller or the isLogin notifier itself changes
      // (though listening directly handles value changes)
    },
    [
      isLoginModeNotifier,
      loginEmailController,
      loginPasswordController,
      signUpEmailController,
      signUpPasswordController,
      signUpRepeatPasswordController,
    ],
  );

  // Return the current enabled state
  return isEnabled.value;
}
