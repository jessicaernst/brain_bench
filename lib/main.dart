import 'dart:async';

import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/app/app.dart';
import 'package:brain_bench/core/utils/file_cleanup_utils.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/firebase_auth_repository_impl.dart';
import 'package:brain_bench/services/firebase_options_dev.dart' as dev;
import 'package:brain_bench/services/firebase_options_prod.dart' as prod;
import 'package:brain_bench/services/firebase_options_test.dart' as test;
import 'package:brain_bench/services/logging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the available Firebase environments
enum FirebaseEnvironment { dev, test, prod }

// Provide the current environment based on --dart-define or build mode
final firebaseEnvProvider = Provider<FirebaseEnvironment>((ref) {
  const env = String.fromEnvironment('FIREBASE_ENV');
  return switch (env) {
    'prod' => FirebaseEnvironment.prod,
    'test' => FirebaseEnvironment.test,
    'dev' => FirebaseEnvironment.dev,
    _ => kReleaseMode ? FirebaseEnvironment.prod : FirebaseEnvironment.dev,
  };
});

final _log = LoggingService('BrainBenchMain');

Future<void> main() async {
  // Everything (bindings + runApp) must execute in the SAME zone.
  runZonedGuarded(
    () async {
      // Init logging as early as possible (inside the zone)
      _log.init();

      // Ensure Flutter bindings are ready (inside this zone!)
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();

      // Keep native splash until initialization completes
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Determine current environment from build flag or fallback to mode
      const env = String.fromEnvironment('FIREBASE_ENV');
      final firebaseEnv = switch (env) {
        'prod' => FirebaseEnvironment.prod,
        'test' => FirebaseEnvironment.test,
        'dev' => FirebaseEnvironment.dev,
        _ => kReleaseMode ? FirebaseEnvironment.prod : FirebaseEnvironment.dev,
      };

      // Select Firebase config based on current environment
      final firebaseOptions = switch (firebaseEnv) {
        FirebaseEnvironment.prod => prod.DefaultFirebaseOptions.currentPlatform,
        FirebaseEnvironment.test => test.DefaultFirebaseOptions.currentPlatform,
        FirebaseEnvironment.dev => dev.DefaultFirebaseOptions.currentPlatform,
      };

      // Initialize hyphenation dictionary
      try {
        _log.info('Initializing Hyphenation...');
        await initHyphenation();
        _log.info('Hyphenation initialized successfully.');
      } catch (e, s) {
        _log.severe('Failed to initialize Hyphenation', e, s);
      }

      // Initialize SharedPreferences
      _log.info('Initializing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      _log.info('SharedPreferences initialized.');

      // Initialize Firebase (guard duplicate-app on hot restart)
      try {
        await Firebase.initializeApp(options: firebaseOptions);
      } on FirebaseException catch (e) {
        if (e.code != 'duplicate-app') rethrow;
      }

      // Enable Crashlytics collection also in dev/debug
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Useful diagnostic context
      await FirebaseCrashlytics.instance.setUserIdentifier('env:$firebaseEnv');
      await FirebaseCrashlytics.instance.setCustomKey(
        'build_mode',
        kReleaseMode ? 'release' : (kProfileMode ? 'profile' : 'debug'),
      );

      // Wire Crashlytics for Flutter framework errors (fatal)
      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // Wire Crashlytics for platform/async errors (fatal)
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true; // prevent double-reporting
      };

      // Lock orientation to portrait mode
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      // Initialize Rive runtime
      try {
        _log.info('Initializing Rive runtime...');
        await RiveFile.initialize();
        _log.info('✅ Rive runtime initialized successfully.');
      } catch (e, s) {
        _log.severe('❌ Error initializing Rive runtime.', e, s);
        rethrow;
      }

      // Fire-and-forget cleanup of old temporary files
      unawaited(
        cleanupOldTempFiles(prefix: 'contact_image_ensure_user_')
            .then(
              (_) => _log.info(
                'Temporary contact image cleanup process initiated.',
              ),
            )
            .catchError(
              (e, s) =>
                  _log.warning('Temporary contact image cleanup failed.', e, s),
            ),
      );

      // Launch app with selected environment injected via provider
      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            firebaseEnvProvider.overrideWithValue(firebaseEnv),
            authRepositoryProvider.overrideWithValue(FirebaseAuthRepository()),
          ],
          child: const BrainBenchApp(),
        ),
      );

      // Remove splash after first frame to avoid flicker
      bool splashRemoved = false;
      void removeSplash() {
        if (!splashRemoved) {
          FlutterNativeSplash.remove();
          splashRemoved = true;
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        removeSplash();
      });

      // Fallback: Remove splash after 3 seconds in case of error before first frame
      Future.delayed(const Duration(seconds: 3), () {
        removeSplash();
      });
    },
    (error, stack) {
      // Catch any uncaught async errors as fatal
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
