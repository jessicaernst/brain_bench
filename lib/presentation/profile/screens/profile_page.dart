import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ProfilePage');

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final textTheme = TextTheme.of(context);

    final userAsyncValue = ref.watch(currentUserModelProvider);

    // Extract image URL separately as before, handling its specific loading/error
    final String? userImageUrl = userAsyncValue.when(
      data: (user) => user?.photoUrl,
      loading: () => null, // No image while loading user data
      error: (err, stack) => null, // No image on error
    );

    return Scaffold(
      appBar: CloseNavAppBar(
        title: localizations.profileAppBarTitle,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          // Add padding for better spacing from edges
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture Section
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .primaryColor
                          .withAlpha((0.4 * 255).toInt()),
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl) as ImageProvider
                        : Assets.images.evolution4.provider(),
                    onBackgroundImageError: (exception, stackTrace) {
                      _logger.warning('Error loading user image: $exception');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 64),
              // User Details Section (Handles Loading/Error/Data)
              GlassCardView(
                content: userAsyncValue.when(
                  data: (user) {
                    if (user == null) {
                      // Handle case where user data is unexpectedly null
                      return Text(
                        localizations.profileUserNotFound,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                    // Display Username and Email
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      // Center children horizontally within the column
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // Assuming 'displayName' exists in your AppUser model
                          user.displayName ?? localizations.profileNoUsername,
                          style: textTheme.headlineMedium,
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
                    _logger.severe(
                        'Error loading user profile data: $err', err, stack);
                    return Text(
                      localizations.profileErrorLoading,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              // Removed the 'Profile coming soon...' text
            ],
          ),
        ),
      ),
    );
  }
}
