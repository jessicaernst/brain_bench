import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_content_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_page_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

final Logger _logger = Logger('ProfilePage');

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isEditing = useState(false);
    final previousIsEditing = usePrevious(isEditing.value);
    final selectedImage = useState<XFile?>(null);

    final userAsyncValue = ref.watch(currentUserModelProvider);
    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color iconColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());

    final profileUpdateState = ref.watch(profileNotifierProvider);

    ref.listen<AsyncValue<void>>(profileNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          _logger.warning('Profile update failed', error, stackTrace);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${localizations.profileUpdateError}: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (_) {
          if (previous is AsyncLoading) {
            _logger.info('Profile update successful, listener triggered.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.profileUpdateSuccess),
                backgroundColor: BrainBenchColors.correctAnswerGlass,
              ),
            );
            isEditing.value = false;
            selectedImage.value = null;
          }
        },
      );
    });

    useEffect(() {
      void updateControllers(user) {
        if (user != null) {
          if (!isEditing.value || displayNameController.text.isEmpty) {
            displayNameController.text = user.displayName ?? '';
          }
          emailController.text = user.email ?? '';
        } else {
          displayNameController.clear();
          emailController.clear();
        }
      }

      final subscription =
          ref.listenManual(currentUserModelProvider, (_, next) {
        next.whenData(updateControllers);
      });

      userAsyncValue.whenData(updateControllers);
      return subscription.close;
    }, [userAsyncValue, isEditing.value]);

    final String? userImageUrl = userAsyncValue.when(
      data: (user) => user?.photoUrl,
      loading: () => null,
      error: (err, stack) => null,
    );

    final originalDisplayName = userAsyncValue.value?.displayName ?? '';
    // Important: Listen to controller changes to re-evaluate 'hasChanges'
    final currentDisplayName = useListenable(displayNameController).text.trim();
    final nameChanged = currentDisplayName != originalDisplayName;
    // Also listen to selectedImage changes
    final imageChanged = useListenable(selectedImage).value != null;
    final bool hasChanges = nameChanged || imageChanged;

    // --- Determine if save buttons should be enabled ---
    // Enabled if there are changes AND not currently saving
    final bool isSaveEnabled = hasChanges && !profileUpdateState.isLoading;
    // --- End Determination ---

    void handleImageSelection(XFile imageFile) {
      _logger.info('Image selected in ProfilePage: ${imageFile.path}');
      selectedImage.value = imageFile;
    }

    void handleSaveChanges() {
      // Prevent saving if button is not enabled (covers loading and no changes)
      if (!isSaveEnabled) {
        _logger.info(
            'Save button pressed but not enabled (Loading: ${profileUpdateState.isLoading}, HasChanges: $hasChanges). Ignoring.');
        return;
      }

      // Get the final display name value
      final finalDisplayName = displayNameController.text.trim();

      _logger.info(
          'Save changes pressed. Original Name: "$originalDisplayName", New Name: "$finalDisplayName"');
      _logger.fine('Selected Image: ${selectedImage.value?.path ?? "None"}');

      // Validation (empty name - only if name actually changed)
      if (nameChanged && finalDisplayName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.profileDisplayNameEmptyError)),
        );
        return;
      }

      // Call the notifier action
      _logger.info('Changes detected, calling profile update notifier.');
      ref.read(profileNotifierProvider.notifier).updateProfile(
            displayName: finalDisplayName,
            // newImageFile: selectedImage.value, // Pass file when TODO is resolved in Notifier
          );
    }

    void toggleEditMode() {
      _logger.fine('Toggling edit mode. Current state: ${isEditing.value}');
      if (!isEditing.value) {
        userAsyncValue.whenData((user) {
          if (user != null) {
            displayNameController.text = user.displayName ?? '';
          }
        });
        selectedImage.value = null;
      } else {
        selectedImage.value = null;
        userAsyncValue.whenData((user) {
          if (user != null) {
            displayNameController.text = user.displayName ?? '';
          }
        });
      }
      isEditing.value = !isEditing.value;
    }

    void backAction() {
      if (isEditing.value) {
        _logger.fine('Back action in edit mode. Discarding changes.');
        selectedImage.value = null;
        userAsyncValue.whenData((user) {
          if (user != null) {
            displayNameController.text = user.displayName ?? '';
          }
        });
        isEditing.value = false;
      } else {
        _logger.fine('Back action in view mode. Popping route.');
        context.pop();
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
            icon: profileUpdateState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(radius: 10),
                  )
                : (isEditing.value
                    ? (defaultTargetPlatform == TargetPlatform.iOS
                        ? Icon(CupertinoIcons.floppy_disk, color: iconColor)
                        : Icon(Icons.save, color: iconColor))
                    : (defaultTargetPlatform == TargetPlatform.iOS
                        ? Icon(CupertinoIcons.pencil, color: iconColor)
                        : Icon(Icons.edit, color: iconColor))),
            // Use isSaveEnabled to determine if onPressed is null
            onPressed: isEditing.value
                ? (isSaveEnabled ? handleSaveChanges : backAction)
                : toggleEditMode, // Edit button always enabled when not loading
            tooltip: isEditing.value
                ? localizations.profileSaveTooltip
                : localizations.profileEditTooltip,
          ),
        ],
      ),
      body: Stack(
        children: [
          const ProfilePageBackground(),
          SafeArea(
            child: ProfileContentView(
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
              userAsyncValue: userAsyncValue,
              handleImageSelection: handleImageSelection,
              handleSaveChanges: handleSaveChanges,
            ),
          ),
        ],
      ),
    );
  }
}
