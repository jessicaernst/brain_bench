import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('useImagePickerSimulator');

/// A custom hook that provides a simulated image picker functionality.
/// This hook is intended for use in development environments only.
/// It allows the user to pick an image from the gallery and returns the selected image.
ImagePickerResult useImagePickerWrapperInternal(bool _) {
  final selectedImageState = useState<XFile?>(null);
  final picker = useMemoized(() => ImagePicker());

  /// Internal function to pick an image from the gallery.
  /// Optionally takes a [BuildContext] parameter, but it is not used in this implementation.
  Future<void> pickImageInternal([BuildContext? context]) async {
    if (context == null) {
      _logger
          .warning('Context is null – required for picker UI and permissions.');
      return;
    }

    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      _logger.warning('AppLocalizations not found in context.');
      return;
    }
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (pickedFile != null) {
        selectedImageState.value = pickedFile;
      }
    } catch (e) {
      debugPrint('Simulator image picker failed: $e');
    }
  }

  return ImagePickerResult(
    selectedImage: selectedImageState,
    pickImage: pickImageInternal,
  );
}
