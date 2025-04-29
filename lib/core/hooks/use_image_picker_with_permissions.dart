import 'dart:io';

import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

final _logger = Logger('useImagePickerWithPermissions');

// Helper to bundle the hook's result
class ImagePickerResult {
  final ValueNotifier<XFile?> selectedImage; // The state of the selected image
  final Future<void> Function(BuildContext, AppLocalizations)
      pickImage; // The trigger function

  ImagePickerResult({required this.selectedImage, required this.pickImage});
}

// The Custom Hook
ImagePickerResult useImagePickerWithPermissions() {
  // Manage the state for the selected image within the hook
  final selectedImageState = useState<XFile?>(null);
  // Create ImagePicker only once using useMemoized
  final picker = useMemoized(() => ImagePicker());

  // The actual logic for selecting an image and checking permissions
  Future<void> pickImageInternal(
      BuildContext context, AppLocalizations localizations) async {
    ImageSource? source;

    // 1. Select source (BottomSheet)
    try {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext sheetContext) {
          // --- BottomSheet UI ---
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
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black87, // Example colors
                    ),
                    title: Text(
                      localizations.profilePickFromGallery,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.gallery),
                  ),
                  ListTile(
                    leading: Icon(
                      Platform.isIOS
                          ? CupertinoIcons.camera_fill
                          : Icons.camera_alt,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                    title: Text(
                      localizations.profilePickFromCamera,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.camera),
                  ),
                ],
              ),
            ),
          );
          // --- End BottomSheet UI ---
        },
      );
      if (source == null) {
        _logger.info('Image source selection cancelled.');
        return; // User closed the bottom sheet
      }
    } catch (e, s) {
      _logger.severe('Error showing image source picker', e, s);
      return; // Exit if showing the picker failed
    }

    // 2. Check and request permission
    PermissionStatus status;
    Permission permission;
    // --- Logic to determine the correct permission ---
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      // ImageSource.gallery
      // Use Permission.photos for newer SDKs, otherwise storage
      if (Platform.isAndroid && (await _getAndroidSdkVersion() ?? 0) >= 33 ||
          Platform.isIOS) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    }
    // --- End Logic ---

    _logger.fine('Checking permission: $permission');
    status = await permission.status;
    _logger.fine('Initial permission status: $status');

    // Request permission if it was denied before (but not permanently)
    if (status.isDenied) {
      _logger.info('Requesting permission: $permission');
      status = await permission.request();
      _logger.info('Permission status after request: $status');
    }

    // 3. Evaluate permission status
    if (status.isGranted || status.isLimited) {
      // isLimited is relevant for iOS photo access
      // 4. Permission granted -> Invoke ImagePicker
      _logger.info('Permission granted/limited. Launching image picker...');
      try {
        final XFile? pickedFile = await picker.pickImage(
          source: source,
          imageQuality: 80, // Optional: Adjust quality
          maxWidth: 1024, // Optional: Limit dimensions
        );
        if (pickedFile != null) {
          _logger.info('Image selected: ${pickedFile.path}');
          // --- Update state within the hook ---
          selectedImageState.value = pickedFile;
          // ---
        } else {
          _logger.info('Image selection cancelled or failed.');
          // Optional: Reset state if necessary
          // selectedImageState.value = null;
        }
      } catch (e, s) {
        _logger.severe('Error picking image', e, s);
        // Show error message to the user if the context is still valid
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.profileImagePickerError)),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      // 5. Permission permanently denied -> Show dialog guiding to settings
      _logger.warning('Permission $permission permanently denied.');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(localizations.permissionRequiredTitle),
            content: Text(source == ImageSource.camera
                ? localizations.permissionCameraPermanentlyDenied
                : localizations.permissionPhotosPermanentlyDenied),
            actions: <Widget>[
              TextButton(
                child: Text(localizations.cancel),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: Text(localizations.openSettings),
                onPressed: () {
                  openAppSettings(); // Opens the app's settings page
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      // 6. Permission denied (again) -> Show SnackBar
      _logger.warning('Permission $permission denied.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(source == ImageSource.camera
                ? localizations.permissionCameraDenied
                : localizations.permissionPhotosDenied),
          ),
        );
      }
    }
  }

  // Return the state and the trigger function
  return ImagePickerResult(
    selectedImage: selectedImageState,
    pickImage: pickImageInternal,
  );
}

// Private helper function for SDK version (can also reside here)
Future<int?> _getAndroidSdkVersion() async {
  if (Platform.isAndroid) {
    // Requires 'device_info_plus' package
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }
  return null; // Return null for non-Android platforms
}
