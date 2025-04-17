import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
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

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // --- State for Edit Mode ---
    final isEditing = useState(false);
    // Track previous state for animation direction (optional but nice)
    final previousIsEditing = usePrevious(isEditing.value);

    final userAsyncValue = ref.watch(currentUserModelProvider);

    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color iconColor = isDarkMode
        ? BrainBenchColors.flutterSky
        : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt());

    // Populate controllers when user data is available and we switch to edit mode
    // This useEffect ensures controllers are updated if user data changes
    // while the page is open, BEFORE entering edit mode.
    useEffect(() {
      // Function to update controllers from user data
      void updateControllers(user) {
        if (user != null) {
          displayNameController.text = user.displayName ?? '';
          emailController.text = user.email ?? '';
        } else {
          displayNameController.clear();
          emailController.clear();
        }
      }

      // Listen to user data changes
      userAsyncValue.whenData(updateControllers);

      // Return null because we don't need a cleanup function here
      return null;
      // Depend on userAsyncValue to re-run when data changes
    }, [userAsyncValue]);

    // Extract image URL separately
    final String? userImageUrl = userAsyncValue.when(
      data: (user) => user?.photoUrl,
      loading: () => null,
      error: (err, stack) => null,
    );

    // --- Save Profile Logic ---
    void handleSaveChanges() {
      // TODO: Implement actual profile update logic
      // Example: Call a view model method
      // ref.read(profileViewModelProvider.notifier).updateProfile(
      //   displayName: displayNameController.text.trim(),
      //   // email usually isn't updated here, but depends on your logic
      // );
      _logger.info(
          'Save changes pressed. Display Name: ${displayNameController.text}');
      // After saving (or attempting to save), switch back to view mode
      isEditing.value = false;
    }

    // --- Toggle Edit Mode ---
    void toggleEditMode() {
      // If switching *to* edit mode, ensure controllers have the latest data
      if (!isEditing.value) {
        userAsyncValue.whenData((user) {
          if (user != null) {
            displayNameController.text = user.displayName ?? '';
            emailController.text = user.email;
          }
        });
      }
      // Toggle the state
      isEditing.value = !isEditing.value;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CloseNavAppBar(
        title: isEditing.value
            ? localizations.profileEditAppBarTitle
            : localizations.profileAppBarTitle,
        onBack: () {
          if (isEditing.value) {
            isEditing.value = false;
          } else {
            context.pop();
          }
        },
        leadingIconColor: iconColor,
        actions: [
          IconButton(
            // Change icon based on mode
            icon: isEditing.value
                ? (defaultTargetPlatform == TargetPlatform.iOS
                    ? Icon(CupertinoIcons.floppy_disk, color: iconColor)
                    : Icon(Icons.save, color: iconColor))
                : (defaultTargetPlatform == TargetPlatform.iOS
                    ? Icon(CupertinoIcons.pencil, color: iconColor)
                    : Icon(Icons.edit, color: iconColor)),
            onPressed: isEditing.value
                ? handleSaveChanges
                : toggleEditMode, // Change action based on mode
          ),
        ],
      ),
      body: Stack(
        children: [
          const ProfilePageBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
              // --- Animated Switcher ---
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds: 400), // Adjust duration as needed
                  // Define the transition (e.g., slide and fade)
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    // Determine slide direction based on previous state
                    final bool enteringEditMode =
                        (previousIsEditing == false && isEditing.value == true);
                    final offsetAnimation = Tween<Offset>(
                      // Slide in from right when entering edit, from left when exiting
                      begin: Offset(enteringEditMode ? 1.0 : -1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child, // The incoming widget
                      ),
                    );
                  },
                  // The child depends on the isEditing state
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
