import 'dart:io'; // Import für File hinzugefügt

import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

final Logger _logger = Logger('ProfileEditView');

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({
    super.key,
    required this.displayNameController,
    required this.emailController,
    required this.localizations,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
    required this.onPressed,
    required this.isActive,
    this.onImageSelected,
    this.selectedImageFile,
  });

  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final AppLocalizations localizations;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;
  final VoidCallback onPressed;
  final Function(XFile)? onImageSelected;
  final XFile? selectedImageFile;
  final bool isActive;

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    try {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext sheetContext) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoIcons.photo_fill_on_rectangle_fill
                          : Icons.photo_library,
                      color: isDarkMode
                          ? BrainBenchColors.cloudCanvas
                          : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      localizations.profilePickFromGallery,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.gallery),
                  ),
                  ListTile(
                    leading: Icon(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoIcons.camera_fill
                          : Icons.camera_alt,
                      color: isDarkMode
                          ? BrainBenchColors.cloudCanvas
                          : BrainBenchColors.deepDive,
                    ),
                    title: Text(
                      localizations.profilePickFromCamera,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () =>
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

      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile != null && onImageSelected != null) {
        _logger.info('Image selected: ${pickedFile.path}');
        onImageSelected!(pickedFile);
      } else {
        _logger.info('Image selection cancelled or failed.');
      }
    } catch (e) {
      _logger.severe('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.profileImagePickerError),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? displayImage;
    if (selectedImageFile != null) {
      displayImage = FileImage(File(selectedImageFile!.path));
    } else if (userImageUrl != null && userImageUrl!.isNotEmpty) {
      displayImage = NetworkImage(userImageUrl!);
    } else {
      displayImage = Assets.images.evolution4.provider();
    }

    return GlassCardView(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor.withAlpha((0.4 * 255).toInt()),
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: displayImage,
                    onBackgroundImageError: (exception, stackTrace) {
                      if (displayImage is NetworkImage) {
                        _logger
                            .warning('Error loading network image: $exception');
                      } else if (displayImage is FileImage) {
                        _logger.warning('Error loading file image: $exception');
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.surface
                        .withAlpha((0.95 * 255).toInt()),
                    child: IconButton(
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.camera_fill
                            : Icons.camera_alt,
                        color: theme.primaryColor,
                      ),
                      iconSize: 24,
                      tooltip: localizations.profileChangePictureTooltip,
                      onPressed: () => _pickImage(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          TextField(
            controller: displayNameController,
            style:
                textTheme.bodyLarge?.copyWith(color: BrainBenchColors.deepDive),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: localizations.profileDisplayNameLabel,
              border: InputBorder.none,
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            readOnly: true,
            style: textTheme.bodyLarge?.copyWith(
                color:
                    BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt())),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: localizations.profileEmailLabel,
              border: InputBorder.none,
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
          ),
          const SizedBox(height: 48),
          LightDarkSwitchBtn(
            title: localizations.profileEditBtnLbl,
            isActive: isActive,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
