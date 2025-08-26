import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('useImagePickerSimulator');

/// A custom hook that provides a simulated image picker functionality.
/// This hook is intended for use in development environments only (e.g. iOS Simulator).
/// It displays a bottom sheet for source selection (camera or gallery) but skips all permission handling.
ImagePickerResult useImagePickerWrapperInternal(bool _) {
  final selectedImageState = useState<XFile?>(null);
  final picker = useMemoized(() => ImagePicker());

  /// Internal function to pick an image using a bottom sheet source selector.
  /// Accepts an optional [BuildContext] (required to show the sheet).
  Future<void> pickImageInternal([BuildContext? context]) async {
    if (context == null) {
      _logger.warning('Context is null – required for BottomSheet UI.');
      return;
    }

    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      _logger.warning('AppLocalizations not found in context.');
      return;
    }

    ImageSource? source;

    try {
      // Show source selection bottom sheet (camera or gallery)
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext sheetContext) {
          final theme = Theme.of(sheetContext);
          final isDarkMode = theme.brightness == Brightness.dark;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      P.isIOS
                          ? CupertinoIcons.photo_fill_on_rectangle_fill
                          : Icons.photo_library,
                      color:
                          isDarkMode
                              ? BrainBenchColors.cloudCanvas
                              : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      localizations.profilePickFromGallery,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap:
                        () =>
                            Navigator.of(sheetContext).pop(ImageSource.gallery),
                  ),
                  ListTile(
                    leading: Icon(
                      P.isIOS ? CupertinoIcons.camera_fill : Icons.camera_alt,
                      color:
                          isDarkMode
                              ? BrainBenchColors.cloudCanvas
                              : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      localizations.profilePickFromCamera,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap:
                        () =>
                            Navigator.of(sheetContext).pop(ImageSource.camera),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (source == null) {
        _logger.info('Image source selection cancelled.');
        return;
      }
    } catch (e, s) {
      _logger.severe('Error showing image source picker', e, s);
      return;
    }

    // Pick image directly (no permissions in simulator)
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (pickedFile != null) {
        _logger.info('Image selected: ${pickedFile.path}');
        selectedImageState.value = pickedFile;
      } else {
        _logger.info('Image selection cancelled.');
      }
    } catch (e, s) {
      _logger.severe('Error picking image', e, s);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.profileImagePickerError)),
        );
      }
    }
  }

  return ImagePickerResult(
    selectedImage: selectedImageState,
    pickImage: pickImageInternal,
  );
}
