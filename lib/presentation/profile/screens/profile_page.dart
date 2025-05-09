import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/shared_widgets/appbars/close_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/backgrounds/profile_settings_page_background.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/profile/widgets/profile_content_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isEditing = useState(false);
    final previousIsEditing = usePrevious(isEditing.value);
    final selectedImage = useState<XFile?>(null);

    final userStateAsync = ref.watch(currentUserModelProvider);
    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor =
        isDarkMode
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
                '${localizations.profileUpdateError}: ${error.toString()}',
              ),
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

    useEffect(() {
      void updateControllers(AppUser user) {
        if (!isEditing.value || displayNameController.text.isEmpty) {
          displayNameController.text = user.displayName ?? '';
        }
        emailController.text = user.email;
      }

      final subscription = ref.listenManual(currentUserModelProvider, (
        _,
        next,
      ) {
        next.whenData((state) {
          if (state is UserModelData) updateControllers(state.user);
        });
      });

      userStateAsync.whenData((state) {
        if (state is UserModelData) updateControllers(state.user);
      });

      return subscription.close;
    }, [userStateAsync, isEditing.value]);

    final String? userImageUrl = userStateAsync.when(
      data:
          (state) => switch (state) {
            UserModelData(:final user) => user.photoUrl,
            _ => null,
          },
      loading: () => null,
      error: (err, stack) => null,
    );

    final originalDisplayName = userStateAsync.when(
      data:
          (state) => switch (state) {
            UserModelData(:final user) => user.displayName ?? '',
            _ => '',
          },
      loading: () => 'Loading...',
      error: (err, stack) => 'Error',
    );

    final currentDisplayName = useListenable(displayNameController).text.trim();
    final nameChanged = currentDisplayName != originalDisplayName;

    final imageChanged = selectedImage.value != null;
    final bool hasChanges = nameChanged || imageChanged;

    final bool isSaveEnabled = hasChanges && !profileUpdateState.isLoading;

    void handleImageSelection(XFile imageFile) {
      _logger.info('Image selected in ProfilePage: ${imageFile.path}');
      selectedImage.value = imageFile;
    }

    void handleSaveChanges() {
      if (!isSaveEnabled) {
        _logger.info(
          'Save button pressed but not enabled (Loading: ${profileUpdateState.isLoading}, HasChanges: $hasChanges). Ignoring.',
        );
        return;
      }

      final finalDisplayName = displayNameController.text.trim();

      _logger.info(
        'Save changes pressed. Original Name: "$originalDisplayName", New Name: "$finalDisplayName"',
      );
      _logger.fine('Selected Image: ${selectedImage.value?.path ?? "None"}');

      if (nameChanged && finalDisplayName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.profileDisplayNameEmptyError)),
        );
        return;
      }

      _logger.info('Changes detected, calling profile update notifier.');
      ref
          .read(profileNotifierProvider.notifier)
          .updateProfile(displayName: finalDisplayName);
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

    IconData? leadingAppBarIcon;
    if (isEditing.value) {
      leadingAppBarIcon =
          defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoIcons.chevron_back
              : Icons.arrow_back;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CloseNavAppBar(
        title:
            isEditing.value
                ? localizations.profileEditAppBarTitle
                : localizations.profileAppBarTitle,
        onBack: backAction,
        leadingIconColor: iconColor,
        leadingIcon: leadingAppBarIcon,
        actions: [
          IconButton(
            icon:
                profileUpdateState.isLoading
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
            onPressed:
                isEditing.value
                    ? (isSaveEnabled ? handleSaveChanges : backAction)
                    : toggleEditMode,
            tooltip:
                isEditing.value
                    ? localizations.profileSaveTooltip
                    : localizations.profileEditTooltip,
          ),
        ],
      ),
      body: Stack(
        children: [
          const ProfileSettingsPageBackground(),
          SafeArea(
            child: userStateAsync.when(
              data: (state) {
                return switch (state) {
                  UserModelData(:final user) => ProfileContentView(
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
                  UserModelError(:final message) => Center(
                    child: Text('${localizations.profileLoadError}: $message'),
                  ),
                };
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error:
                  (error, stack) => Center(
                    child: Text('${localizations.profileLoadError}: $error'),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
