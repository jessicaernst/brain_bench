// lib/core/hooks/shared/use_image_picker_wrapper.dart
import 'package:brain_bench/core/hooks/prod/image_picker_impl.dart'
    as image_picker_impl;
import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// Returns the result of the image picker. Passes whether we're on an iOS simulator (debug) to the impl.
ImagePickerResult useImagePickerWrapper() {
  final bool isSimulator = P.isIOS && P.isSimulator && kDebugMode;
  return image_picker_impl.useImagePickerWrapperInternal(isSimulator);
}
