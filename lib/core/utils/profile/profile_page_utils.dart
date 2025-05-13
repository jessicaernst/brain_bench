import 'dart:io';

import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

/// A class that holds the [TextEditingController] instances for the display name and email fields.
class ProfileControllers {
  final TextEditingController displayNameController;
  final TextEditingController emailController;

  ProfileControllers()
    : displayNameController = TextEditingController(),
      emailController = TextEditingController();

  /// Disposes the text editing controllers.
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
  }
}

/// A function that validates the selected image file based on its extension.
bool validateSelectedImage(
  XFile imageFile,
  void Function(String extension) onError,
) {
  const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
  final extension = imageFile.path.split('.').last.toLowerCase();

  if (!validExtensions.contains(extension)) {
    onError(extension);
    return false;
  }
  return true;
}

/// A class that handles the saving of a user's profile.
class ProfileSaveHandler {
  final Logger logger;
  final WidgetRef ref;
  final AppLocalizations localizations;

  ProfileSaveHandler({
    required this.logger,
    required this.ref,
    required this.localizations,
  });

  /// Saves the user's profile with the provided data.
  void save({
    required bool isSaveEnabled,
    required String originalDisplayName,
    required String currentDisplayName,
    required XFile? selectedImage,
    required VoidCallback onValidationError,
  }) {
    if (!isSaveEnabled) {
      logger.info('Save button pressed but not enabled. Ignoring.');
      return;
    }

    if (currentDisplayName.isEmpty &&
        currentDisplayName != originalDisplayName) {
      onValidationError();
      return;
    }

    logger.info(
      'Saving profile. Name: "$currentDisplayName", Image: ${selectedImage?.path ?? "None"}',
    );

    ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(
          displayName: currentDisplayName,
          profileImageFile:
              selectedImage != null ? File(selectedImage.path) : null,
        );
  }
}
