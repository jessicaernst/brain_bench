import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileButtonView extends ConsumerWidget {
  const ProfileButtonView({
    super.key,
    required this.userImageUrl,
    required this.profilePressed,
    required this.settingsPressed,
  });

  final String? userImageUrl;
  final VoidCallback profilePressed;
  final VoidCallback settingsPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                Theme.of(context).primaryColor.withAlpha((0.4 * 255).toInt()),
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: userImageUrl != null
              ? NetworkImage(userImageUrl!) as ImageProvider
              : Assets.images.evolution4.provider(),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading error if needed
            debugPrint('Error loading user image: $exception');
          },
        ),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'profile':
            profilePressed();
          case 'settings':
            settingsPressed();
          case 'logout':
            ref.read(authViewModelProvider.notifier).signOut(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(
              CupertinoIcons.profile_circled,
              color: isDarkMode
                  ? BrainBenchColors.cloudCanvas
                  : BrainBenchColors.deepDive,
            ),
            title: Text(
              'Profile',
              style: TextTheme.of(context).bodyLarge,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: ListTile(
            leading: Icon(
              CupertinoIcons.settings,
              color: isDarkMode
                  ? BrainBenchColors.cloudCanvas
                  : BrainBenchColors.deepDive,
            ),
            title: Text(
              'Settings',
              style: TextTheme.of(context).bodyLarge,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: isDarkMode
                  ? BrainBenchColors.cloudCanvas
                  : BrainBenchColors.deepDive,
            ),
            title: Text(
              'Logout',
              style: TextTheme.of(context).bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
