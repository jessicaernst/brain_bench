import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_edit_view.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_page_background.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

final Logger _logger = Logger('ProfilePage');

// TODO: Create a ViewModel/Provider for profile updates
// final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(...);

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // --- State for Edit Mode ---
    final isEditing = useState(false);
    final previousIsEditing = usePrevious(isEditing.value);
    // --- State for selected image ---
    final selectedImage = useState<XFile?>(null); // <-- NEU

    final userAsyncValue = ref.watch(currentUserModelProvider);
    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    // --- This color will be passed down ---
    final Color iconColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());

    useEffect(() {
      void updateControllers(user) {
        if (user != null) {
          displayNameController.text = user.displayName ?? '';
          emailController.text = user.email ?? '';
        } else {
          displayNameController.clear();
          emailController.clear();
        }
      }

      userAsyncValue.whenData(updateControllers);
      return null;
    }, [userAsyncValue]);

    final String? userImageUrl = userAsyncValue.when(
      data: (user) => user?.photoUrl,
      loading: () => null,
      error: (err, stack) => null,
    );

    // --- Image Selection Handler ---
    void handleImageSelection(XFile imageFile) {
      // <-- NEU
      _logger.info('Image selected in ProfilePage: ${imageFile.path}');
      // Set the selected image in state so it can be displayed
      selectedImage.value = imageFile;
      // TODO: Add image upload logic here (e.g., via ViewModel)
      // This is where you'd trigger the upload if you want immediate upload,
      // or just store it until 'Save' is pressed.
    }

    // --- Save Profile Logic ---
    void handleSaveChanges() {
      _logger.info(
          'Save changes pressed. Display Name: ${displayNameController.text}');

      // TODO: Implement actual profile update logic
      // 1. Check if a new image was selected (selectedImage.value != null)
      // 2. If yes, upload the image (e.g., via ViewModel)
      //    - Wait for the new URL from storage
      //    - Then update the user profile (e.g., in Firestore/Auth) with name AND new URL
      // 3. If no, update only the user profile with the name
      // Example call:
      // ref.read(profileViewModelProvider.notifier).updateProfile(
      //   displayName: displayNameController.text.trim(),
      //   newImageFile: selectedImage.value, // Pass the file to the ViewModel
      // );

      // --- IMPORTANT: Reset temporary image state after saving ---
      selectedImage.value = null; // <-- NEU
      isEditing.value = false; // Switch back to view mode
    }

    // --- Toggle Edit Mode ---
    void toggleEditMode() {
      if (!isEditing.value) {
        // When switching *to* edit mode: Fill controllers
        userAsyncValue.whenData((user) {
          if (user != null) {
            displayNameController.text = user.displayName ?? '';
            emailController.text = user.email;
          }
        });
        // Ensure no old selected image is shown from a previous edit session
        selectedImage.value = null;
      } else {
        // When switching *out* of edit mode (without saving): Discard selection
        selectedImage.value = null;
      }
      // Toggle the state
      isEditing.value = !isEditing.value;
    }

    // --- Back Action ---
    void backAction() {
      if (isEditing.value) {
        // When leaving edit mode (without saving) via back button: Discard selection
        selectedImage.value = null;
        isEditing.value = false;
      } else {
        context.pop(); // Close page
      }
    }

    IconData? leadingAppBarIcon;
    if (isEditing.value) {
      leadingAppBarIcon = defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoIcons.chevron_back
          : Icons.arrow_back;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CloseNavAppBar(
        title: isEditing.value
            ? localizations.profileEditAppBarTitle
            : localizations.profileAppBarTitle,
        onBack: backAction,
        leadingIconColor: iconColor,
        leadingIcon: leadingAppBarIcon,
        actions: [
          IconButton(
            icon: isEditing.value
                ? (defaultTargetPlatform == TargetPlatform.iOS
                    ? Icon(CupertinoIcons.floppy_disk, color: iconColor)
                    : Icon(Icons.save, color: iconColor))
                : (defaultTargetPlatform == TargetPlatform.iOS
                    ? Icon(CupertinoIcons.pencil, color: iconColor)
                    : Icon(Icons.edit, color: iconColor)),
            onPressed: isEditing.value ? handleSaveChanges : toggleEditMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          const ProfilePageBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final bool enteringEditMode =
                        (previousIsEditing == false && isEditing.value == true);
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(enteringEditMode ? 1.0 : -1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut));

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
            ),
          ),
        ],
      ),
    );
  }
}
