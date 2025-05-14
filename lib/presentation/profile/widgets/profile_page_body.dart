import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_content_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageBody extends HookConsumerWidget {
  const ProfilePageBody({
    super.key,
    required this.userStateAsync,
    required this.localizations,
    required this.previousIsEditing,
    required this.isEditing,
    required this.displayNameController,
    required this.emailController,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
    required this.isSaveEnabled,
    required this.selectedImage,
    required this.contactImageFile, // This will now be XFile? directly
    required this.handleImageSelection,
    required this.handleSaveChanges,
  });

  final AsyncValue<UserModelState> userStateAsync;
  final AppLocalizations localizations;
  final bool? previousIsEditing;
  final ValueNotifier<bool> isEditing;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;
  final bool isSaveEnabled;
  final ValueNotifier<XFile?> selectedImage;
  final XFile? contactImageFile; // Changed from ValueNotifier<XFile?> to XFile?
  final void Function(XFile) handleImageSelection;
  final VoidCallback handleSaveChanges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return userStateAsync.when(
      data: (UserModelState state) {
        return switch (state) {
          UserModelData(:final AppUser user) => ProfileContentView(
            previousIsEditing: previousIsEditing,
            isEditing: isEditing,
            displayNameController: displayNameController,
            emailController: emailController,
            localizations: localizations,
            textTheme: textTheme,
            theme: theme,
            userImageUrl: userImageUrl,
            isSaveEnabled: isSaveEnabled,
            selectedImage: selectedImage,
            contactImageFile: contactImageFile, // Pass the XFile? directly
            userAsyncValue: AsyncData(user),
            handleImageSelection: handleImageSelection,
            handleSaveChanges: handleSaveChanges,
          ),
          UserModelLoading() => const Center(
            child: CupertinoActivityIndicator(),
          ),
          UserModelUnauthenticated() => Center(
            child: Text(localizations.profileUserNotFound),
          ),
          UserModelError(:final String message) => Center(
            child: Text('${localizations.profileLoadError}: $message'),
          ),
        };
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error:
          (Object error, StackTrace stack) =>
              Center(child: Text('${localizations.profileLoadError}: $error')),
    );
  }
}
