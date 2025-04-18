import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_edit_view.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileContentView extends StatelessWidget {
  const ProfileContentView({
    super.key,
    required this.previousIsEditing,
    required this.isEditing,
    required this.displayNameController,
    required this.emailController,
    required this.localizations,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
    required this.isSaveEnabled,
    required this.selectedImage,
    required this.userAsyncValue,
    required this.handleSaveChanges,
    required this.handleImageSelection,
  });

  final bool? previousIsEditing;
  final ValueNotifier<bool> isEditing;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final AppLocalizations localizations;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;
  final bool isSaveEnabled;
  final ValueNotifier<XFile?> selectedImage;
  final AsyncValue<AppUser?> userAsyncValue;
  final VoidCallback handleSaveChanges;
  final Function(XFile)? handleImageSelection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final bool enteringEditMode =
                (previousIsEditing == false && isEditing.value == true);
            final offsetAnimation = Tween<Offset>(
              begin: Offset(enteringEditMode ? 1.0 : -1.0, 0.0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut));

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: isEditing.value
              ? ProfileEditView(
                  key: const ValueKey('profile_edit_view'),
                  displayNameController: displayNameController,
                  emailController: emailController,
                  localizations: localizations,
                  textTheme: textTheme,
                  theme: theme,
                  userImageUrl: userImageUrl,
                  // Pass isSaveEnabled to control the button state
                  isActive: isSaveEnabled, // <-- Pass calculated state
                  // Pass handleSaveChanges, button disables itself if !isActive
                  onPressed: handleSaveChanges,
                  onImageSelected: handleImageSelection,
                  selectedImageFile: selectedImage.value,
                )
              : ProfileView(
                  key: const ValueKey('profile_view'),
                  userAsyncValue: userAsyncValue,
                  localizations: localizations,
                  textTheme: textTheme,
                  theme: theme,
                  userImageUrl: userImageUrl,
                ),
        ),
      ),
    );
  }
}
