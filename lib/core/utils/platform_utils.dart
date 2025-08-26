import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'platform_env_stub.dart' if (dart.library.io) 'platform_env_io.dart';

class P {
  static bool get isWeb => kIsWeb;
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMobile => isAndroid || isIOS;

  /// Simulator detection (only meaningful on iOS)
  static bool get isSimulator {
    if (!isIOS) return false;
    try {
      return platformEnvironment().containsKey('SIMULATOR_DEVICE_NAME');
    } catch (_) {
      return false;
    }
  }
}
