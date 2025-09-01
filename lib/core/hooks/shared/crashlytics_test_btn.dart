import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A debug-only button to test Crashlytics error reporting.
/// Add it temporarily to any screen, press it, and check Firebase Console.
class CrashlyticsTestBtn extends StatelessWidget {
  const CrashlyticsTestBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('🔥 Test Crashlytics'),
      onPressed: () async {
        try {
          // Simulate an error
          throw Exception('Test exception from CrashlyticsTestButton');
        } catch (e, st) {
          // Record error manually
          await FirebaseCrashlytics.instance.recordError(
            e,
            st,
            reason: 'Manual Crashlytics test',
            fatal: false,
          );

          // Give user feedback
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Test error sent to Crashlytics ✅')),
            );
          }
        }
      },
    );
  }
}

/// A debug-only button to trigger a fatal crash in Crashlytics.
/// DO NOT ship this in production builds.
class CrashlyticsFatalBtn extends StatelessWidget {
  const CrashlyticsFatalBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      child: const Text('💥 Force Fatal Crash'),
      onPressed: () {
        if (kDebugMode) {
          // FlutterFire helper to force a crash
          FirebaseCrashlytics.instance.crash();
        } else {
          // As a fallback: throw an uncaught exception
          throw StateError('Forced fatal crash outside debug mode');
        }
      },
    );
  }
}
