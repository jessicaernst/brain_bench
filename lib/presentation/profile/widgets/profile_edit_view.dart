import 'dart:io';

import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/hooks/shared/use_image_picker_wrapper.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfileEditView');

class ProfileEditView extends HookWidget {
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

  @override
  Widget build(BuildContext context) {
    final imagePickerLogic = useImagePickerWrapper();

    useEffect(() {
      final selectedFile = imagePickerLogic.selectedImage.value;
      if (selectedFile != null && onImageSelected != null) {
        // Use a post-frame callback to avoid calling setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (onImageSelected != null) {
            _logger.info('Notifying parent via onImageSelected callback.');
            onImageSelected!(selectedFile);
          }
        });
      }
      // No cleanup needed, just react to changes
      return null;
      // Listen specifically to the value from the hook's notifier
    }, [imagePickerLogic.selectedImage.value]);

    // Determine which image to display based on the HOOK's state
    ImageProvider? displayImage;
    // Use the hook's state for the preview
    if (imagePickerLogic.selectedImage.value != null) {
      displayImage =
          FileImage(File(imagePickerLogic.selectedImage.value!.path));
    } else if (userImageUrl != null && userImageUrl!.isNotEmpty) {
      // Fallback to userImageUrl if hook state is null
      displayImage = NetworkImage(userImageUrl!);
    } else {
      // Fallback to default asset
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
                // Display the profile picture
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
                    backgroundImage:
                        displayImage, // Uses image from hook or URL
                    onBackgroundImageError: (exception, stackTrace) {
                      _logger
                          .warning('Error loading profile image: $exception');
                    },
                  ),
                ),
                // Edit button overlay on the profile picture
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
                      // Trigger the hook's pickImage function
                      onPressed: () => imagePickerLogic.pickImage(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          // Display Name TextField
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
          // Email TextField (read-only)
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
          // Action Button (Save)
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
