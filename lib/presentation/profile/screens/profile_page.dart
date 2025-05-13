import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/backgrounds/profile_settings_page_background.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/utils/profile/profile_page_utils.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_page_app_bar.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfilePage');

class ProfilePage extends HookConsumerWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final ValueNotifier<bool> isEditing = useState(false);
    final bool? previousIsEditing = usePrevious(isEditing.value);
    final ValueNotifier<XFile?> selectedImage = useState<XFile?>(null);

    final AsyncValue<UserModelState> userStateAsync = ref.watch(
      currentUserModelProvider,
    );

    final controllers = useMemoized(() => ProfileControllers());
    final displayNameController = controllers.displayNameController;
    final emailController = controllers.emailController;

    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor =
        isDarkMode
            ? BrainBenchColors.flutterSky
            : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());

    final AsyncValue<void> profileUpdateState = ref.watch(
      profileNotifierProvider,
    );

    ref.listen<AsyncValue<void>>(profileNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          String displayMessage;
          // Check if the error message indicates an image upload failure specifically
          if (error.toString().toLowerCase().contains('image upload failed')) {
            displayMessage = localizations.profileUpdateSuccessButImageFailed;
            _logger.warning(
              'Profile updated, but image upload failed.',
              error,
              stackTrace,
            );
          } else {
            displayMessage =
                '${localizations.profileUpdateError}: ${error.toString()}';
            _logger.severe(
              'Profile update failed completely.',
              error,
              stackTrace,
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
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

    // Effect to synchronize controllers with user data
    useEffect(() {
      void updateControllers(AppUser user) {
        // Only update displayNameController if not editing or if it's empty,
        // to preserve user's ongoing edits.
        if (!isEditing.value || displayNameController.text.isEmpty) {
          displayNameController.text = user.displayName ?? '';
        }
        // Email is usually not editable by the user directly in this screen,
        // so it can be updated more freely.
        emailController.text = user.email;
      }

      // Listen to changes in currentUserModelProvider
      final subscription = ref.listenManual<AsyncValue<UserModelState>>(
        currentUserModelProvider,
        (
          AsyncValue<UserModelState>? previous,
          AsyncValue<UserModelState> next,
        ) {
          next.whenData((state) {
            if (state is UserModelData) updateControllers(state.user);
          });
        },
      );

      // Initial sync when the widget builds or userStateAsync changes
      userStateAsync.whenData((state) {
        if (state is UserModelData) updateControllers(state.user);
      });

      // Cleanup the listener when the widget is disposed or dependencies change
      return subscription.close;
    }, [userStateAsync, isEditing.value]); // Dependencies for the effect
    // Dispose controllers when the widget is unmounted
    useEffect(
      () {
        return controllers.dispose;
      },
      [controllers],
    ); // Rerun effect if controllers instance changes (should not happen with useMemoized)

    final String? userImageUrl = userStateAsync.when(
      data:
          (UserModelState state) => switch (state) {
            UserModelData(:final AppUser user) => user.photoUrl,
            _ => null,
          },
      loading: () => null,
      error: (Object err, StackTrace stack) => null,
    );

    final String originalDisplayName = userStateAsync.when(
      data:
          (UserModelState state) => switch (state) {
            UserModelData(:final AppUser user) => user.displayName ?? '',
            _ => '',
          },
      loading: () => 'Loading...',
      error: (Object err, StackTrace stack) => 'Error',
    );

    final String currentDisplayName =
        useListenable(displayNameController).text.trim();
    final bool nameChanged = currentDisplayName != originalDisplayName;
    final bool imageChanged = selectedImage.value != null;
    final bool hasChanges = nameChanged || imageChanged;
    final bool isSaveEnabled = hasChanges && !profileUpdateState.isLoading;

    void handleImageSelection(XFile imageFile) {
      final isValid = validateSelectedImage(imageFile, (ext) {
        _logger.warning(
          'Invalid or missing image file extension: "$ext" for file: ${imageFile.path}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.profileInvalidImageFormat)),
        );
      });

      if (isValid) {
        _logger.info('Valid image selected in ProfilePage: ${imageFile.path}');
        selectedImage.value = imageFile;
      }
    }

    void handleSaveChanges() {
      final saveHandler = ProfileSaveHandler(
        logger: _logger,
        ref: ref,
        localizations: localizations,
      );

      saveHandler.save(
        isSaveEnabled: isSaveEnabled,
        originalDisplayName: originalDisplayName,
        currentDisplayName: currentDisplayName,
        selectedImage: selectedImage.value,
        onValidationError: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.profileDisplayNameEmptyError)),
          );
        },
      );
    }

    void toggleEditMode() {
      _logger.fine('Toggling edit mode. Current state: ${isEditing.value}');
      if (!isEditing.value) {
        userStateAsync.whenData((state) {
          if (state is UserModelData) {
            displayNameController.text = state.user.displayName ?? '';
          }
        });
        selectedImage.value = null;
      } else {
        selectedImage.value = null;
        userStateAsync.whenData((state) {
          if (state is UserModelData) {
            displayNameController.text = state.user.displayName ?? '';
          }
        });
      }
      isEditing.value = !isEditing.value;
    }

    void backAction() {
      if (isEditing.value) {
        _logger.fine('Back action in edit mode. Discarding changes.');
        selectedImage.value = null;
        userStateAsync.whenData((state) {
          if (state is UserModelData) {
            displayNameController.text = state.user.displayName ?? '';
          }
        });
        isEditing.value = false;
      } else {
        _logger.fine('Back action in view mode. Popping route.');
        context.pop();
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ProfilePageAppBar(
        isEditing: isEditing.value,
        profileUpdateIsLoading: profileUpdateState.isLoading,
        localizations: localizations,
        iconColor: iconColor,
        isSaveEnabled: isSaveEnabled,
        onSaveChanges: handleSaveChanges,
        onToggleEditMode: toggleEditMode,
        onBackAction: backAction,
      ),
      body: Stack(
        children: [
          const ProfileSettingsPageBackground(),
          SafeArea(
            child: ProfilePageBody(
              userStateAsync: userStateAsync,
              localizations: localizations,
              previousIsEditing: previousIsEditing,
              isEditing: isEditing,
              displayNameController: displayNameController,
              emailController: emailController,
              textTheme: textTheme,
              theme: theme,
              userImageUrl: userImageUrl,
              isSaveEnabled: isSaveEnabled,
              selectedImage: selectedImage,
              handleImageSelection: handleImageSelection,
              handleSaveChanges: handleSaveChanges,
            ),
          ),
        ],
      ),
    );
  }
}
