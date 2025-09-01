// lib/core/hooks/prod/image_picker_impl.dart
//
// Robust image picker hook with:
// - Runtime iOS Simulator detection (no false positives on Apple Silicon)
// - Permission bypass on Web and iOS Simulator
// - Proper permission handling on real devices (iOS/Android)
// - Debug logging gated behind kDebugMode
// - Consistent severe error logging in both Debug and Production (with Crashlytics integration)

import 'package:brain_bench/core/hooks/shared/image_picker_result.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

final _logger = Logger('useImagePickerImpl');

/// Unified severe logging:
/// - Debug: full context with stacktrace
/// - Prod: compact log + Crashlytics error reporting
void _logSevere(String message, Object error, StackTrace stack) {
  if (kDebugMode) {
    _logger.severe(message, error, stack);
  } else {
    _logger.severe('$message: $error');
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, reason: message);
    } catch (_) {
      // Defensive: do not crash if Crashlytics is not available
    }
  }
}

ImagePickerResult useImagePickerWrapperInternal(bool isWebFlag) {
  final selectedImageState = useState<XFile?>(null);
  final picker = useMemoized(() => ImagePicker());

  /// Runtime iOS Simulator detection:
  /// - Primary: ios.isPhysicalDevice == false
  /// - Conservative fallback: treat only x86/i386 as simulator
  ///   (Do NOT use 'arm64' to avoid false positives on Apple Silicon Macs)
  Future<bool> isIosSimulatorRuntime() async {
    if (!P.isIOS) return false;
    try {
      final ios = await DeviceInfoPlugin().iosInfo;

      if (ios.isPhysicalDevice == false) return true;

      final machine = (ios.utsname.machine).toLowerCase();
      if (machine.contains('x86') || machine == 'i386') return true;
    } catch (e, st) {
      if (kDebugMode) {
        _logger.fine('iOS simulator detection failed (fallback false)', e, st);
      }
    }
    return false;
  }

  Future<void> pickImageInternal([BuildContext? context]) async {
    if (context == null) {
      if (kDebugMode) {
        _logger.warning('Context is null – required for picker UI.');
      }
      return;
    }
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      if (kDebugMode) _logger.warning('AppLocalizations not found in context.');
      return;
    }

    if (kDebugMode) {
      _logger.info(
        '[Picker] platform: ios=${P.isIOS} android=${P.isAndroid} web=$kIsWeb, webFlag=$isWebFlag',
      );
    }

    // --- 1) Ask user: gallery or camera ------------------------------------
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
        if (kDebugMode) _logger.info('Image source selection cancelled.');
        return;
      }
    } catch (e, s) {
      _logSevere('Error showing image source picker', e, s);
      return;
    }

    // --- 2) Web: no permissions, just pick ---------------------------------
    if (isWebFlag) {
      if (kDebugMode) _logger.info('[Picker] BYPASS on Web');
      try {
        final file = await picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1024,
        );
        selectedImageState.value = file;
      } catch (e, s) {
        _logSevere('Error picking image (web)', e, s);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.profileImagePickerError)));
        }
      }
      return;
    }

    // --- 3) iOS Simulator: bypass permissions ------------------------------
    final isiOSSim = await isIosSimulatorRuntime();
    if (kDebugMode) _logger.info('[Picker] iOS simulator detected = $isiOSSim');
    if (isiOSSim) {
      if (kDebugMode) {
        _logger.info('[Picker] BYPASS on iOS Simulator (no permissions)');
      }
      try {
        final file = await picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1024,
        );
        selectedImageState.value = file;
      } catch (e, s) {
        _logSevere('Error picking image (iOS simulator)', e, s);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.profileImagePickerError)));
        }
      }
      return;
    }

    // --- 4) Real devices: permission handling ------------------------------
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (P.isIOS) {
        permission = Permission.photos;
      } else {
        final sdk = await _getAndroidSdkVersion() ?? 0;
        permission =
            (P.isAndroid && sdk >= 33) ? Permission.photos : Permission.storage;
      }
    }

    var status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }

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

    // --- 5) Allowed → open picker ------------------------------------------
    try {
      final file = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      selectedImageState.value = file;
    } catch (e, s) {
      _logSevere('Error picking image (device)', e, s);
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
