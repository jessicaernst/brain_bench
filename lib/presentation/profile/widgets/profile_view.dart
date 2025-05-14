import 'dart:io';

import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/cards/glass_card_view.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfileView');

class ProfileView extends ConsumerWidget {
  const ProfileView({
    super.key,
    required this.userAsyncValue,
    required this.localizations,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
    this.contactImageFile, // Neuer Parameter
  });

  final AsyncValue<AppUser?> userAsyncValue;
  final AppLocalizations localizations;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;
  final XFile? contactImageFile; // Neues Feld

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCardView(
      content: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            // Handle case where user data is unexpectedly null
            return Text(
              localizations.profileUserNotFound,
              style: textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            );
          }

          ImageProvider? finalBackgroundImage;
          Widget? avatarChild;

          if (userImageUrl != null && userImageUrl!.isNotEmpty) {
            _logger.finer('ProfileView: Using Firebase image: $userImageUrl');
            // CachedNetworkImage will be the child.
            // CircleAvatar's own backgroundImage can be a fallback if CNI fails AND CNI's errorWidget is SizedBox.shrink().
            finalBackgroundImage =
                Assets.images.evolution4.provider(); // Fallback for CNI
            avatarChild = ClipOval(
              child: CachedNetworkImage(
                imageUrl: userImageUrl!,
                fit: BoxFit.cover,
                width: 160,
                height: 160,
                placeholder:
                    (context, url) =>
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? const CupertinoActivityIndicator(radius: 15)
                            : const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  _logger.warning(
                    'ProfileView: Error loading Firebase image via CNI: $error. CircleAvatar will show its own backgroundImage (asset).',
                  );
                  return const SizedBox.shrink();
                },
              ),
            );
          } else if (contactImageFile != null) {
            _logger.finer(
              'ProfileView: Using contact image: ${contactImageFile!.path}',
            );
            finalBackgroundImage = FileImage(File(contactImageFile!.path));
            avatarChild = null; // Using backgroundImage
          } else {
            _logger.finer('ProfileView: Using default placeholder asset.');
            finalBackgroundImage = Assets.images.evolution4.provider();
            avatarChild = null; // Using backgroundImage
          }
          // Display Username and Email
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor.withAlpha((0.4 * 255).toInt()),
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent, // For glass effect
                    backgroundImage: finalBackgroundImage,
                    onBackgroundImageError:
                        (finalBackgroundImage is FileImage)
                            ? (exception, stackTrace) {
                              _logger.warning(
                                'ProfileView: Error loading contact image (FileImage) as backgroundImage: $exception. CircleAvatar will show transparent background.',
                              );
                              // Clear the provisional image so that on the next rebuild,
                              // the logic falls back to the default asset.
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref
                                    .read(
                                      provisionalProfileImageProvider.notifier,
                                    )
                                    .clearImage();
                              });
                            }
                            : null,
                    child: avatarChild,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Text(
                // Assuming 'displayName' exists in your AppUser model
                user.displayName ?? localizations.profileNoUsername,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                user.email,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) {
          _logger.severe('Error loading user profile data: $err', err, stack);
          return Text(
            localizations.profileErrorLoading,
            style: textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
