import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          localizations.appBarTitleHome,
          style: TextTheme.of(context).displaySmall,
        ),
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
                'Home coming soon . . .',
                style: TextTheme.of(context).displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
