// /Users/jessicaernst/Projects/brain_bench/lib/presentation/profile/screens/profile_page.dart
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: BackNavAppBar(
        title:
            'Profile', // Consider using localizations.profileTitle or similar
        onBack: () => context.pop(), // Use context.pop() to go back
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Assets.images.dashLogo.image(
                  width: 350,
                  height: 350,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Profile coming soon . . .', // Consider using localizations
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
