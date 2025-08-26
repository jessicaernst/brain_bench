import 'dart:typed_data';

import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
    final XFile? provisionalImage = ref.watch(provisionalProfileImageProvider);

    final String? userImageUrl = switch (userState) {
      AsyncData(value: UserModelData(:final user)) => user.photoUrl,
      _ => null,
    };

    // local builder to avoid duplicating the menu markup
    Widget buildMenu({
      required ImageProvider? backgroundImage,
      required Widget? avatarChild,
    }) {
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
            backgroundColor: theme.colorScheme.surface.withAlpha(100),
            backgroundImage: backgroundImage,
            child: avatarChild,
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
              ref.read(authViewModelProvider.notifier).signOut();
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

    ImageProvider? displayImageProvider;
    Widget? avatarChild;

    // case 1: user photo URL -> keep CNI as child, asset as fallback background
    if (userImageUrl != null && userImageUrl.isNotEmpty) {
      _logger.finer('ProfileButtonView: Using Firebase image: $userImageUrl');
      avatarChild = ClipOval(
        child: CachedNetworkImage(
          imageUrl: userImageUrl,
          fit: BoxFit.cover,
          width: 36,
          height: 36,
          placeholder:
              (context, url) =>
                  defaultTargetPlatform == TargetPlatform.iOS
                      ? const CupertinoActivityIndicator(radius: 8)
                      : const CircularProgressIndicator(strokeWidth: 2.0),
          errorWidget: (context, url, error) {
            _logger.warning(
              'ProfileButtonView: Error loading Firebase image via CNI: $error.',
            );
            return const SizedBox.shrink();
          },
        ),
      );
      displayImageProvider = Assets.images.evolution4.provider();
      return buildMenu(
        backgroundImage: displayImageProvider,
        avatarChild: avatarChild,
      );
    }

    // case 2: provisional XFile -> MemoryImage as backgroundImage (web-safe)
    if (provisionalImage != null) {
      _logger.finer(
        'ProfileButtonView: Using provisional contact image: ${provisionalImage.path}',
      );
      return FutureBuilder<Uint8List>(
        future: provisionalImage.readAsBytes(),
        builder: (context, snap) {
          ImageProvider bg = Assets.images.evolution4.provider();

          if (snap.connectionState == ConnectionState.done && snap.hasData) {
            bg = MemoryImage(snap.data!);
          } else if (snap.hasError) {
            _logger.warning(
              'ProfileButtonView: Error reading provisional XFile bytes. Clearing provisional image.',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(provisionalProfileImageProvider.notifier).clearImage();
            });
          }

          return buildMenu(backgroundImage: bg, avatarChild: null);
        },
      );
    }

    // case 3: fallback asset
    displayImageProvider = Assets.images.evolution4.provider();
    avatarChild = null;
    return buildMenu(
      backgroundImage: displayImageProvider,
      avatarChild: avatarChild,
    );
  }
}
