import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';

import 'package:brain_bench/core/hooks/prod/image_picker_impl.dart'
    if (dart.library.html) 'package:brain_bench/core/hooks/prod/image_picker_impl.dart'
    if (dart.library.io) 'package:brain_bench/core/hooks/dev_only/image_picker_impl.dart'
    as image_picker_impl;

ImagePickerResult useImagePickerWrapper() {
  final isSimulator = Platform.isIOS &&
      !Platform.isMacOS &&
      kDebugMode &&
      Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');

  return image_picker_impl.useImagePickerWrapperInternal(isSimulator);
}
