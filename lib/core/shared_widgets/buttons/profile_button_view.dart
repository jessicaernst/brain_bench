import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfileButtonView');

final class ProfileButtonView extends ConsumerWidget {
  const ProfileButtonView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final userState = ref.watch(currentUserModelProvider);

    final String? userImageUrl = switch (userState) {
      AsyncData(value: UserModelData(:final user)) => user.photoUrl,
      _ => null,
    };

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(
              context,
            ).primaryColor.withAlpha((0.4 * 255).toInt()),
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.surface.withAlpha(
            100,
          ), // Background for placeholder/error
          backgroundImage:
              Assets.images.evolution4.provider(), // Default fallback
          child:
              userImageUrl != null && userImageUrl.isNotEmpty
                  ? ClipOval(
                    // Ensure the CachedNetworkImage is clipped to a circle
                    child: CachedNetworkImage(
                      imageUrl: userImageUrl,
                      fit: BoxFit.cover, // Make the image fill the circle
                      width: 36, // 2 * radius
                      height: 36, // 2 * radius
                      placeholder:
                          (context, url) =>
                              defaultTargetPlatform == TargetPlatform.iOS
                                  ? const CupertinoActivityIndicator(radius: 8)
                                  : const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                      errorWidget: (context, url, error) {
                        _logger.warning(
                          'Error loading profile button image: $error',
                        );
                        // backgroundImage (fallback asset) will be shown
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                  : null, // If no userImageUrl, the backgroundImage (fallback asset) is used
        ),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'profile':
            context.push('/profile');
            break;
          case 'settings':
            context.push('/settings');
            break;
          case 'logout':
            ref.read(authViewModelProvider.notifier).signOut(context);
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'profile',
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.profile_circled,
                  color:
                      isDarkMode
                          ? BrainBenchColors.cloudCanvas
                          : BrainBenchColors.deepDive,
                ),
                title: Text(
                  localizations.profileMenuProfile,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.settings,
                  color:
                      isDarkMode
                          ? BrainBenchColors.cloudCanvas
                          : BrainBenchColors.deepDive,
                ),
                title: Text(
                  localizations.profileMenuSettings,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color:
                      isDarkMode
                          ? BrainBenchColors.cloudCanvas
                          : BrainBenchColors.deepDive,
                ),
                title: Text(
                  localizations.profileMenuLogout,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
    );
  }
}
