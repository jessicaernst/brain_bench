import 'package:brain_bench/core/shared_widgets/cards/glass_card_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfileView');

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.userAsyncValue,
    required this.localizations,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
  });

  final AsyncValue<AppUser?> userAsyncValue;
  final AppLocalizations localizations;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        userImageUrl != null
                            ? NetworkImage(userImageUrl!) as ImageProvider
                            : Assets.images.evolution4.provider(),
                    onBackgroundImageError: (exception, stackTrace) {
                      _logger.warning('Error loading user image: $exception');
                    },
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
