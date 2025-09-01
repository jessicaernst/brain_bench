import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

final _logger = Logger('useImagePickerImplProd');

/// Runtime-flag decides: bypass permissions on web/simulator/emulator,
/// otherwise do proper permission handling on real devices.
ImagePickerResult useImagePickerWrapperInternal(bool isSimOrWeb) {
  final selectedImageState = useState<XFile?>(null);
  final picker = useMemoized(() => ImagePicker());

  Future<void> pickImageInternal([BuildContext? context]) async {
    if (context == null) {
      _logger.warning('Context is null – required for picker UI.');
      return;
    }
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      _logger.warning('AppLocalizations not found in context.');
      return;
    }

    // Source selection (gallery / camera)
    ImageSource? source;
    try {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (sheetContext) {
          final theme = Theme.of(sheetContext);
          final isDark = theme.brightness == Brightness.dark;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(
                      P.isIOS
                          ? CupertinoIcons.photo_fill_on_rectangle_fill
                          : Icons.photo_library,
                      color:
                          isDark
                              ? BrainBenchColors.cloudCanvas
                              : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      l10n.profilePickFromGallery,
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
                          isDark
                              ? BrainBenchColors.cloudCanvas
                              : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      l10n.profilePickFromCamera,
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

    // --- BYPASS on web/simulator/emulator ---------------------------------
    if (isSimOrWeb) {
      try {
        final XFile? file = await picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1024,
        );
        selectedImageState.value = file;
      } catch (e, s) {
        _logger.severe('Error picking image (sim/web)', e, s);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.profileImagePickerError)));
        }
      }
      return;
    }

    // --- REAL DEVICES: permission handling --------------------------------
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      final sdk = await _getAndroidSdkVersion() ?? 0;
      // Parentheses fixed: (Android && sdk>=33) || iOS
      if ((P.isAndroid && sdk >= 33) || P.isIOS) {
        permission = Permission.photos; // READ_MEDIA_IMAGES (A13+) / iOS Photos
      } else {
        permission = Permission.storage; // Android <= 12
      }
    }

    _logger.fine('Checking permission: $permission');
    var status = await permission.status;
    _logger.fine('Initial permission status: $status');

    if (status.isDenied) {
      _logger.info('Requesting permission: $permission');
      status = await permission.request();
      _logger.info('Permission status after request: $status');
    }

    // iOS: "Limited" is OK for picking – do not force upgrade
    final allowed = status.isGranted || status.isLimited;
    if (!allowed) {
      if (status.isPermanentlyDenied || status.isRestricted) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text(l10n.permissionRequiredTitle),
                  content: Text(
                    permission == Permission.camera
                        ? l10n.permissionCameraPermanentlyDenied
                        : l10n.permissionPhotosPermanentlyDenied,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        openAppSettings();
                        Navigator.of(ctx).pop();
                      },
                      child: Text(l10n.openSettings),
                    ),
                  ],
                ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                permission == Permission.camera
                    ? l10n.permissionCameraDenied
                    : l10n.permissionPhotosDenied,
              ),
            ),
          );
        }
      }
      return;
    }

    try {
      final XFile? file = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      selectedImageState.value = file;
    } catch (e, s) {
      _logger.severe('Error picking image (device)', e, s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.profileImagePickerError)));
      }
    }
  }

  return ImagePickerResult(
    selectedImage: selectedImageState,
    pickImage: pickImageInternal,
  );
}

Future<int?> _getAndroidSdkVersion() async {
  if (!P.isAndroid) return null;
  final info = await DeviceInfoPlugin().androidInfo;
  return info.version.sdkInt;
}
