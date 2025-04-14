import 'dart:async'; // Required for Timer

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rive/rive.dart';

final _logger = Logger('SplashPage');

/// A widget that displays a splash screen with a Rive animation.
///
/// It waits for a minimum display duration and for the authentication state
/// to be resolved before navigating to the appropriate next screen (`/home` or `/login`).
/// It uses `flutter_hooks` for managing local state and side effects.
class SplashPage extends HookConsumerWidget {
  /// Creates a SplashPage widget.
  const SplashPage({super.key});

  /// Defines the minimum duration the splash screen should be visible.
  /// This prevents the splash screen from disappearing too quickly on fast devices
  /// or fast network connections, providing a consistent user experience.
  static const Duration _minDisplayDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Hooks ---
    // These hooks manage the local state of the widget.

    /// Holds the Rive Artboard object once loaded.
    /// Used to display the animation in the `Rive` widget.
    /// Initial value is `null`, indicating the animation hasn't loaded yet.
    final riveArtboard = useState<Artboard?>(null);

    /// Tracks whether the minimum display duration has elapsed.
    /// Initial value is `false`. Set to `true` by the Timer.
    final minTimeElapsed = useState(false);

    /// A flag to ensure navigation is only triggered once.
    /// Prevents potential issues if both the timer and the auth listener
    /// conditions are met very close together. Initial value is `false`.
    final navigationTriggered = useState(false);

    // --- Effects Hook ---
    // `useEffect` handles side effects like data fetching, subscriptions, timers.
    // It runs after the first build and potentially on subsequent builds if dependencies change.
    // The cleanup function returned by `useEffect` runs when the widget is disposed.
    useEffect(() {
      // Local variables within the effect scope.
      RiveAnimationController?
          controllerInstance; // To manage the Rive animation controller
      Timer? minDisplayTimer; // To manage the minimum display timer

      /// Asynchronously loads the Rive animation file and prepares the Artboard.
      Future<void> loadRiveAnimation() async {
        try {
          // Get the path to the Rive asset using the generated Assets class.
          final String rivePath = Assets.rive.helloDash;
          _logger.info('Loading Rive asset from flutter_gen path: $rivePath');

          // Load the binary data of the Rive file from assets.
          final data = await rootBundle.load(rivePath);
          // Import the Rive file data.
          final file = RiveFile.import(data);
          // Get the main artboard from the Rive file.
          final artboard = file.mainArtboard;

          // Attempt to get the state machine controller named 'State Machine 1'.
          // State machine names are defined in the Rive editor.
          final stateMachineController = StateMachineController.fromArtboard(
            artboard,
            'State Machine 1',
          );

          if (stateMachineController != null) {
            // If the state machine controller is found, add it to the artboard.
            artboard.addController(stateMachineController);
            controllerInstance =
                stateMachineController; // Store the controller locally
            riveArtboard.value =
                artboard; // Update the state to display the artboard
            controllerInstance?.isActive = true; // Start the animation playback
            _logger.info('Rive State Machine controller activated.');
          } else {
            // Log a warning if the specified state machine is not found.
            _logger.warning('Could not find State Machine "State Machine 1"');
            // Still display the artboard, but without the state machine animation.
            riveArtboard.value = artboard;
          }
        } catch (e, stack) {
          // Log any errors during Rive loading or initialization.
          _logger.severe('Error loading or playing Rive animation', e, stack);
          // Set artboard to null to show the loading indicator as a fallback.
          // Navigation will still proceed based on the timer and auth state.
          riveArtboard.value = null;
        }
      }

      /// Initializes the splash screen logic: starts the timer and loads Rive animation.
      Future<void> initialize() async {
        // Start loading the Rive animation asynchronously.
        final riveLoadingFuture = loadRiveAnimation();

        // Start the timer for the minimum display duration.
        minDisplayTimer = Timer(_minDisplayDuration, () {
          _logger.info('Minimum display time ($_minDisplayDuration) elapsed.');
          // Mark that the minimum time has passed.
          minTimeElapsed.value = true;
          // Attempt to navigate away from the splash screen now that the timer is done.
          // The function will check if the auth state is also ready.
          _checkAuthAndNavigate(
              ref, context, minTimeElapsed.value, navigationTriggered);
        });

        // Optionally wait for Rive loading to complete. This ensures that any
        // Rive loading errors are caught before the effect is considered "done",
        // but doesn't block the timer from running.
        await riveLoadingFuture;
      }

      // Start the initialization process.
      initialize();

      // --- Cleanup Function ---
      // This function is returned by `useEffect` and runs when the widget is disposed.
      return () {
        _logger.info('Disposing SplashPage resources.');
        // Cancel the timer if it's still active to prevent memory leaks
        // and potential errors if it fires after the widget is gone.
        minDisplayTimer?.cancel();
        // Note: Disposing the Rive controller (`controllerInstance`) is generally
        // handled automatically by the Artboard when it's no longer needed.
        // Explicit disposal here (`controllerInstance?.dispose();`) is usually not required.
      };
    }, const []); // `const []` as the dependency array means this effect runs only once when the widget mounts.

    // --- Listener for Auth State ---
    // `ref.listen` observes a provider (`currentUserProvider`) and executes a callback
    // whenever the provider's state changes. It does NOT rebuild the widget.
    ref.listen<AsyncValue<dynamic>>(currentUserProvider, (_, next) {
      // React only when the authentication state is resolved (i.e., not in a loading state).
      // `next` represents the new state of the `currentUserProvider`.
      if (!next.isLoading) {
        _logger.info(
            'Auth state resolved: isLoading=${next.isLoading}, hasValue=${next.hasValue}, hasError=${next.hasError}');
        // Attempt to navigate away from the splash screen now that the auth state is known.
        // The function will check if the minimum display time has also passed.
        _checkAuthAndNavigate(
            ref, context, minTimeElapsed.value, navigationTriggered);
      }
    });

    // --- UI ---
    // Build the visual representation of the splash screen.

    // Determine the current theme brightness (light or dark).
    final Brightness brightness = Theme.of(context).brightness;
    final bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      // Using a Stack to layer the background image and the Rive animation/loading indicator.
      body: Stack(
        children: [
          // Conditionally display the light mode background image.
          if (isLightMode)
            Positioned.fill(
              // Makes the image fill the entire screen
              child: Assets.backgrounds.lightMode.image(
                fit: BoxFit
                    .cover, // Cover the screen area, cropping if necessary
              ),
            ),
          // Center the main content (Rive animation or loading indicator).
          Center(
            // Display the Rive animation if the artboard has loaded (`riveArtboard.value != null`).
            child: riveArtboard.value != null
                ? Rive(
                    artboard: riveArtboard.value!, // Pass the loaded artboard
                    fit: BoxFit
                        .contain, // Adjust how the animation fits the space
                  )
                // Otherwise (while loading or if an error occurred), display a loading indicator.
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  /// Checks if navigation conditions are met and navigates accordingly.
  ///
  /// This function is called by both the timer callback and the auth state listener.
  /// It ensures that navigation only happens once and only when both conditions
  /// (minimum time elapsed AND auth state resolved) are true.
  void _checkAuthAndNavigate(
    WidgetRef ref, // Riverpod ref to read providers
    BuildContext context, // BuildContext for navigation
    bool hasMinTimeElapsed, // Current state of the timer flag
    ValueNotifier<bool>
        navigationTriggeredNotifier, // State hook to prevent double navigation
  ) {
    // --- Guard Clause: Prevent Multiple Navigations ---
    // If navigation has already been triggered, do nothing further.
    if (navigationTriggeredNotifier.value) {
      _logger.fine('Navigation already triggered, skipping.');
      return;
    }

    // --- Read Current Auth State ---
    // Use `ref.read` to get the *current* value of the auth provider without listening.
    // We don't need `ref.watch` here because this function is triggered by events
    // (timer, listener), not by the build method needing to react to state changes.
    final userAsyncValue = ref.read(currentUserProvider);

    // --- Check Navigation Conditions ---
    // Both conditions must be true to navigate:
    // 1. The minimum display time must have passed (`hasMinTimeElapsed`).
    // 2. The authentication state must NOT be loading (`!userAsyncValue.isLoading`).
    final bool canNavigate = hasMinTimeElapsed && !userAsyncValue.isLoading;

    if (canNavigate) {
      // Conditions met! Proceed with navigation.
      _logger.info(
          'Conditions met for navigation: Min time elapsed and Auth resolved.');
      // Set the flag to true immediately to prevent this block from running again.
      navigationTriggeredNotifier.value = true;

      // --- Determine Target Route ---
      // Check if there is a logged-in user (`userAsyncValue.valueOrNull` is not null).
      final user = userAsyncValue.valueOrNull;
      // Navigate to '/home' if logged in, otherwise to '/login'.
      final targetPath = user != null ? '/home' : '/login';

      _logger.info('Navigating to target path: $targetPath');
      // --- Perform Navigation ---
      // Use `context.go` from go_router. This replaces the current route (`/splash`)
      // in the navigation stack with the `targetPath`, so the user cannot navigate back
      // to the splash screen.
      context.go(targetPath);
    } else {
      // Log why navigation is not happening yet if conditions are not met.
      // This is useful for debugging.
      _logger.fine(
          'Navigation conditions not yet met: minTimeElapsed=$hasMinTimeElapsed, authIsLoading=${userAsyncValue.isLoading}');
    }
  }
}
