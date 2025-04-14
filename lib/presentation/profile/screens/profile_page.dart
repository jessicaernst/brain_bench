import 'package:brain_bench/core/component_widgets/close_nav_app_bar.dart';
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

    final userAsyncValue = ref.watch(currentUserModelProvider);
    final String? userImageUrl = userAsyncValue.when(
      data: (user) => user?.photoUrl,
      loading: () => null,
      error: (err, stack) => null,
    );

    return Scaffold(
      appBar: CloseNavAppBar(
        title: localizations.profileAppBarTitle,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
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
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  backgroundImage: userImageUrl != null
                      ? NetworkImage(userImageUrl) as ImageProvider
                      : Assets.images.evolution4.provider(),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle image loading error if needed
                    _logger.warning('Error loading user image: $exception');
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Profile coming soon . . .',
                // Use Theme.of(context) for text styles
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
