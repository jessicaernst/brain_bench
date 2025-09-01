// lib/core/hooks/shared/use_image_picker_wrapper.dart
import 'package:brain_bench/core/hooks/prod/image_picker_impl.dart' as impl;
import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

ImagePickerResult useImagePickerWrapper() {
  return impl.useImagePickerWrapperInternal(kIsWeb);
}
