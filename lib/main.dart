import 'package:brain_bench/app/app.dart';
import 'package:brain_bench/core/utils/logging_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  // Setup logging for the application
  setupLogging();

  // Ensure that widget binding is initialized
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen until initialization is complete
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set the preferred device orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Remove the splash screen after initialization
  FlutterNativeSplash.remove();

  // Run the application
  runApp(
    const ProviderScope(
      child: BrainBenchApp(),
    ),
  );
}
