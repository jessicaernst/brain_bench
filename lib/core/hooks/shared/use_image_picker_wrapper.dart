import 'dart:io' show Platform;

import 'package:brain_bench/core/hooks/prod/image_picker_impl.dart'
    if (dart.library.html) 'package:brain_bench/core/hooks/prod/image_picker_impl.dart'
    if (dart.library.io) 'package:brain_bench/core/hooks/dev_only/image_picker_impl.dart'
    as image_picker_impl;
import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// A custom hook that wraps the image picker functionality.
/// It determines if the device is a simulator and returns the result of the image picker.
ImagePickerResult useImagePickerWrapper() {
  final isSimulator = Platform.isIOS &&
      kDebugMode &&
      Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');

  return image_picker_impl.useImagePickerWrapperInternal(isSimulator);
}
