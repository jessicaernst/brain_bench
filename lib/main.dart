import 'package:brain_bench/app/app.dart';
import 'package:brain_bench/services/logging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// Import all Firebase config files
import 'package:brain_bench/services/firebase_options_dev.dart' as dev;
import 'package:brain_bench/services/firebase_options_test.dart' as test;
import 'package:brain_bench/services/firebase_options_prod.dart' as prod;

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
  // Initialize logging
  _log.init();

  // Ensure Flutter bindings are ready
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Keep splash screen until initialization completes
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

  // Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Remove splash screen after init
  FlutterNativeSplash.remove();

  // Launch app with selected environment injected via provider
  runApp(
    ProviderScope(
      overrides: [
        firebaseEnvProvider.overrideWithValue(firebaseEnv),
      ],
      child: const BrainBenchApp(),
    ),
  );
}
