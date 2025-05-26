import 'dart:io';

import 'package:brain_bench/core/hooks/shared/use_image_picker_wrapper.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
import 'package:brain_bench/core/shared_widgets/cards/glass_card_view.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/presentation/profile/widgets/delete_account_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    this.contactImageFile,
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
  final XFile? contactImageFile;

  @override
  Widget build(BuildContext context) {
    final imagePickerLogic = useImagePickerWrapper();
    // State to track if loading the contact image prop failed
    final contactImageLoadFailed = useState<bool>(false);

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

    // Determine which image to display with correct priority
    Widget imageDisplayWidget;
    final XFile? imagePickedInThisView = imagePickerLogic.selectedImage.value;
    final XFile? imagePrefilledOrPreviouslySelected = selectedImageFile;
    final String? firebaseImageUrl = userImageUrl;
    final XFile? rawContactImageFromFileProp = contactImageFile;

    if (imagePickedInThisView != null) {
      _logger.finer(
        'ProfileEditView: Displaying image picked in this view: ${imagePickedInThisView.path}',
      );
      imageDisplayWidget = CircleAvatar(
        radius: 80,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(File(imagePickedInThisView.path)),
        onBackgroundImageError: (exception, stackTrace) {
          _logger.warning(
            'ProfileEditView: Error loading image picked in this view: $exception',
          );
        },
      );
    } else if (imagePrefilledOrPreviouslySelected != null) {
      _logger.finer(
        'ProfileEditView: Displaying prefilled/previously selected image: ${imagePrefilledOrPreviouslySelected.path}',
      );
      imageDisplayWidget = CircleAvatar(
        radius: 80,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(
          File(imagePrefilledOrPreviouslySelected.path),
        ),
        onBackgroundImageError: (exception, stackTrace) {
          _logger.warning(
            'ProfileEditView: Error loading prefilled/previously selected image: $exception',
          );
        },
      );
    } else if (firebaseImageUrl != null && firebaseImageUrl.isNotEmpty) {
      _logger.finer(
        'ProfileEditView: Displaying cached network image from URL: $firebaseImageUrl',
      );
      imageDisplayWidget = CachedNetworkImage(
        imageUrl: firebaseImageUrl,
        imageBuilder:
            (context, imageProvider) => CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              backgroundImage: imageProvider,
            ),
        placeholder:
            (context, url) => CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child:
                  defaultTargetPlatform == TargetPlatform.iOS
                      ? const CupertinoActivityIndicator(radius: 15)
                      : const CircularProgressIndicator(),
            ),
        errorWidget: (context, url, error) {
          _logger.warning(
            'ProfileEditView: Error loading Firebase image: $error',
          );
          return CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 80,
            backgroundImage: Assets.images.evolution4.provider(),
          );
        },
      );
      // Check if contact image should be displayed and if it hasn't failed loading
    } else if (rawContactImageFromFileProp != null &&
        !contactImageLoadFailed.value) {
      _logger.finer(
        'ProfileEditView: Displaying contact image from prop: ${rawContactImageFromFileProp.path}',
      );
      imageDisplayWidget = CircleAvatar(
        radius: 80,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(File(rawContactImageFromFileProp.path)),
        onBackgroundImageError: (exception, stackTrace) {
          _logger.warning(
            'ProfileEditView: Error loading contact image from prop: $exception',
          );
          // Set state to indicate failure, so on next rebuild the asset is used
          WidgetsBinding.instance.addPostFrameCallback((_) {
            contactImageLoadFailed.value = true;
          });
        },
      );
    } else {
      _logger.finer('ProfileEditView: Displaying default placeholder image.');
      imageDisplayWidget = CircleAvatar(
        radius: 80,
        backgroundImage: Assets.images.evolution4.provider(),
      );
    }

    return GlassCardView(
      content: SingleChildScrollView(
        primary: false,
        child: Column(
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
                        color: theme.primaryColor.withAlpha(
                          (0.4 * 255).toInt(),
                        ),
                        width: 3.0,
                      ),
                    ),
                    child: imageDisplayWidget,
                  ),
                  // Edit button overlay on the profile picture
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.surface.withAlpha(
                        (0.95 * 255).toInt(),
                      ),
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
              style: textTheme.bodyLarge?.copyWith(
                color: BrainBenchColors.deepDive,
              ),
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
                color: BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt()),
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: localizations.profileEmailLabel,
                border: InputBorder.none,
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
            ),
            const SizedBox(height: 8),
            DeleteAccountButton(),
            const SizedBox(height: 48),
            // Action Button (Save)
            LightDarkSwitchBtn(
              title: localizations.profileEditBtnLbl,
              isActive: isActive,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
