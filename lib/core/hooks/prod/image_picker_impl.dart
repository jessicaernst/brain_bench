import 'dart:io';

import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

final _logger = Logger('useImagePickerWithPermissions');

/// Custom hook for picking an image with permissions.
///
/// This hook provides a function, `pickImageInternal`, that allows the user to pick an image from the gallery or capture a new image using the camera.
/// It handles the necessary permissions and displays a UI for selecting the image source.
///
/// Example usage:
/// ```dart
/// ImagePickerResult useImagePickerWithPermissions() {
///   // ...
/// }
/// ```
///
/// Returns:
/// - An [ImagePickerResult] object that contains the selected image file.
///
/// Throws:
/// - [PermissionDeniedException] if the user denies the required permissions.
/// - [PermissionPermanentlyDeniedException] if the user permanently denies the required permissions.
/// - [PermissionRestrictedException] if the user restricts the required permissions.
/// - [PermissionLimitedException] if the user grants limited permissions.
/// - [PermissionGrantedException] if the user grants the required permissions.
ImagePickerResult useImagePickerWrapperInternal(bool _) {
  final selectedImageState = useState<XFile?>(null);
  final picker = useMemoized(() => ImagePicker());

  Future<void> pickImageInternal([BuildContext? context]) async {
    if (context == null) {
      _logger.warning(
        'Context is null – required for picker UI and permissions.',
      );
      return;
    }

    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      _logger.warning('AppLocalizations not found in context.');
      return;
    }

    ImageSource? source;

    try {
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
                      Platform.isIOS
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
                      Platform.isIOS
                          ? CupertinoIcons.camera_fill
                          : Icons.camera_alt,
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

    PermissionStatus status;
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (Platform.isAndroid && (await _getAndroidSdkVersion() ?? 0) >= 33 ||
          Platform.isIOS) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    }

    _logger.fine('Checking permission: $permission');
    status = await permission.status;
    _logger.fine('Initial permission status: $status');

    if (status.isDenied) {
      _logger.info('Requesting permission: $permission');
      status = await permission.request();
      _logger.info('Permission status after request: $status');
    }

    if (Platform.isIOS && permission == Permission.photos && status.isLimited) {
      _logger.info('iOS limited photo access granted');
      if (!context.mounted) {
        _logger.warning(
          'Context not mounted before prompting for full photo access.',
        );
        return;
      }
      final upgraded = await _promptForFullPhotoAccess(context);
      if (!upgraded) {
        _logger.warning('User did not upgrade photo permission to full access');
        return;
      }
    }

    if (status.isGranted || status.isLimited) {
      _logger.info('Permission granted. Launching picker...');
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
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      _logger.warning('Permission $permission permanently denied.');
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text(localizations.permissionRequiredTitle),
                content: Text(
                  source == ImageSource.camera
                      ? localizations.permissionCameraPermanentlyDenied
                      : localizations.permissionPhotosPermanentlyDenied,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations.cancel),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                  TextButton(
                    child: Text(localizations.openSettings),
                    onPressed: () {
                      openAppSettings();
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
        );
      }
    } else {
      _logger.warning('Permission $permission denied.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? localizations.permissionCameraDenied
                  : localizations.permissionPhotosDenied,
            ),
          ),
        );
      }
    }
  }

  return ImagePickerResult(
    selectedImage: selectedImageState,
    pickImage: pickImageInternal,
  );
}

/// Retrieves the Android SDK version if the current platform is Android.
/// Returns `null` if the current platform is not Android.
Future<int?> _getAndroidSdkVersion() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }
  return null;
}

/// Prompts the user to grant full photo access.
/// Returns a [Future] that resolves to a [bool] indicating whether the user granted full photo access or not.
Future<bool> _promptForFullPhotoAccess(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Full Access Required'),
              content: const Text(
                'To select all photos, please allow full photo access in Settings.',
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
                TextButton(
                  child: const Text('Open Settings'),
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
      ) ??
      false;
}
