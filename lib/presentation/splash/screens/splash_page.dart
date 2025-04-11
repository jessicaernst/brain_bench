import 'dart:async';
import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rive/rive.dart';

// Setup logger for this page
final _logger = Logger('SplashPage');

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  // Minimum time the splash screen should be visible.
  static const Duration _minDisplayDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Hooks ---
    // Holds the Rive Artboard once loaded
    final riveArtboard = useState<Artboard?>(null);
    // Holds the Rive controller
    final riveController = useState<RiveAnimationController?>(null);
    // Tracks if the minimum display time has elapsed
    final minTimeElapsed = useState(false);
    // Prevents triggering navigation multiple times
    final navigationTriggered = useState(false);

    // --- Effects Hook ---
    useEffect(() {
      RiveAnimationController? controllerInstance;
      Timer? minDisplayTimer;

      Future<void> loadAndInitialize() async {
        try {
          final String rivePath = Assets.rive.helloDash;
          _logger.info('Loading Rive asset from flutter_gen path: $rivePath');

          final data = await rootBundle.load(rivePath);
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;

          final stateMachineController = StateMachineController.fromArtboard(
            artboard,
            'State Machine 1',
          );

          if (stateMachineController != null) {
            artboard.addController(stateMachineController);
            controllerInstance = stateMachineController;

            riveArtboard.value = artboard;
            riveController.value = controllerInstance;

            controllerInstance?.isActive = true;
            _logger.info('Rive State Machine controller activated.');
          }

          minDisplayTimer = Timer(_minDisplayDuration, () {
            _logger
                .info('Minimum display time ($_minDisplayDuration) elapsed.');
            minTimeElapsed.value = true;
            _checkAuthAndNavigate(
                ref, context, minTimeElapsed.value, navigationTriggered);
          });
        } catch (e, stack) {
          _logger.severe('Error loading or playing Rive animation', e, stack);
          minDisplayTimer ??= Timer(_minDisplayDuration, () {
            _logger.warning('Navigating after error and min display time.');
            minTimeElapsed.value = true;
            _checkAuthAndNavigate(
                ref, context, minTimeElapsed.value, navigationTriggered);
          });
        }
      }

      loadAndInitialize();

      return () {
        _logger.info('Disposing SplashPage resources.');
        minDisplayTimer?.cancel();
      };
    }, []);

    // --- Listener for Auth State ---
    // Listens to changes in the authentication state provider.
    ref.listen<AsyncValue<dynamic>>(currentUserProvider, (_, next) {
      // Only react when the auth state is resolved (not loading anymore)
      if (!next.isLoading) {
        _logger.info(
            'Auth state resolved: isLoading=${next.isLoading}, hasValue=${next.hasValue}, hasError=${next.hasError}');
        // Attempt navigation now that auth state is known
        _checkAuthAndNavigate(
            ref, context, minTimeElapsed.value, navigationTriggered);
      }
    });

    final Brightness brightness = Theme.of(context).brightness;
    final bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      body: Stack(
        children: [
          if (isLightMode)
            Positioned.fill(
              child: Assets.backgrounds.lightMode.image(
                fit: BoxFit.cover,
              ),
            ),
          Center(
            child: riveArtboard.value != null
                // If Rive artboard is loaded, display the Rive animation
                ? Rive(
                    artboard: riveArtboard.value!,
                    fit: BoxFit.contain,
                  )
                // Otherwise, show a loading indicator while Rive loads
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  // --- Helper Function for Navigation ---
  // Checks if both minimum time has passed and auth state is resolved, then navigates.
  void _checkAuthAndNavigate(WidgetRef ref, BuildContext context,
      bool hasMinTimeElapsed, ValueNotifier<bool> navigationTriggeredNotifier) {
    // Prevent multiple navigation attempts
    if (navigationTriggeredNotifier.value) {
      _logger.fine('Navigation already triggered, skipping.');
      return;
    }

    // Read the current auth state (don't watch, just get the value)
    final userAsyncValue = ref.read(currentUserProvider);

    // Check conditions: Minimum time must have passed AND auth must not be loading
    if (hasMinTimeElapsed && !userAsyncValue.isLoading) {
      _logger.info(
          'Conditions met for navigation: Min time elapsed and Auth resolved.');
      navigationTriggeredNotifier.value = true; // Mark navigation as triggered

      // Determine the target route based on login status
      final user = userAsyncValue.valueOrNull;
      final targetPath = user != null ? '/home' : '/login';

      _logger.info('Navigating to target path: $targetPath');
      // Use context.go to replace the splash screen in the navigation stack
      context.go(targetPath);
    } else {
      // Log why navigation is not happening yet
      _logger.fine(
          'Navigation conditions not yet met: minTimeElapsed=$hasMinTimeElapsed, authIsLoading=${userAsyncValue.isLoading}');
    }
  }
}
