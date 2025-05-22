import 'dart:async';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
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
  SplashPage({super.key});

  /// Defines the minimum duration the splash screen should be visible.
  /// This prevents the splash screen from disappearing too quickly on fast devices
  /// or fast network connections, providing a consistent user experience.
  static const Duration _minDisplayDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Holds the Rive Artboard object once loaded.
    final riveArtboard = useState<Artboard?>(null);

    /// Tracks whether the minimum display duration has elapsed.
    final minTimeElapsed = useState(false);

    /// A flag to ensure navigation is only triggered once.
    final navigationTriggered = useState(false);

    useEffect(() {
      RiveAnimationController? controllerInstance;
      Timer? minDisplayTimer;

      /// Asynchronously loads the Rive animation file and prepares the Artboard.
      Future<void> loadRiveAnimation() async {
        try {
          final String rivePath = Assets.rive.helloDash;
          _logger.info('Loading Rive asset from flutter_gen path: $rivePath');

          // Load the binary data of the Rive file from assets.
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
            controllerInstance?.isActive = true;
            _logger.info('Rive State Machine controller activated.');
          } else {
            _logger.warning('Could not find State Machine "State Machine 1"');
            riveArtboard.value = artboard;
          }
        } catch (e, stack) {
          _logger.severe('Error loading or playing Rive animation', e, stack);
          riveArtboard.value = null;
        }
      }

      /// Initializes the splash screen logic: starts the timer and loads Rive animation.
      Future<void> initialize() async {
        final riveLoadingFuture = loadRiveAnimation();

        minDisplayTimer = Timer(_minDisplayDuration, () {
          _logger.info('Minimum display time ($_minDisplayDuration) elapsed.');
          minTimeElapsed.value = true;
          _checkAuthAndNavigate(
            ref,
            context,
            minTimeElapsed.value,
            navigationTriggered,
          );
        });

        await riveLoadingFuture;
      }

      initialize();

      return () {
        _logger.info('Disposing SplashPage resources.');
        minDisplayTimer?.cancel();
      };
    }, const []);
    // Listens for authentication state changes to trigger navigation.
    ref.listen<AsyncValue<dynamic>>(currentUserProvider, (_, next) {
      if (!next.isLoading) {
        _logger.info(
          'Auth state resolved: isLoading=${next.isLoading}, hasValue=${next.hasValue}, hasError=${next.hasError}',
        );
        _checkAuthAndNavigate(
          ref,
          context,
          minTimeElapsed.value,
          navigationTriggered,
        );
      }
    });

    final Brightness brightness = Theme.of(context).brightness;
    final bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      body: Stack(
        children: [
          if (isLightMode)
            Positioned.fill(
              child: Assets.backgrounds.lightMode.image(fit: BoxFit.cover),
            ),
          Center(
            child:
                riveArtboard.value != null
                    ? Rive(artboard: riveArtboard.value!, fit: BoxFit.contain)
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
  Future<void> _checkAuthAndNavigate(
    WidgetRef ref, // Riverpod ref to read providers
    BuildContext context,
    bool hasMinTimeElapsed, // Current state of the timer flag
    ValueNotifier<bool> navigationTriggeredNotifier,
  ) async {
    if (navigationTriggeredNotifier.value) {
      _logger.fine('Navigation already triggered, skipping.');
      return;
    }

    final userAsyncValue = ref.read(currentUserProvider);

    final bool canNavigate = hasMinTimeElapsed && !userAsyncValue.isLoading;

    if (canNavigate) {
      _logger.info(
        'Conditions met for navigation: Min time elapsed and Auth resolved.',
      );
      navigationTriggeredNotifier.value = true;

      final user = userAsyncValue.valueOrNull;

      if (user != null) {
        _logger.info('User authenticated. Starting initial data load...');
        try {
          await ref.read(initialDataLoadProvider(user.uid).future);
          _logger.info('Initial data load completed successfully.');
          if (context.mounted) {
            _logger.info('Navigating to /home');
            context.go('/home');
          }
        } catch (e, stack) {
          _logger.severe('Error during initial data load', e, stack);
          if (context.mounted) {
            context.go('/home');
          }
        }
      } else {
        _logger.info('No authenticated user. Navigating to /login');
        context.go('/login');
      }
    } else {
      _logger.fine(
        'Navigation conditions not yet met: minTimeElapsed=$hasMinTimeElapsed, authIsLoading=${userAsyncValue.isLoading}',
      );
    }
  }
}
