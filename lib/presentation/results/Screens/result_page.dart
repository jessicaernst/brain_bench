import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/profile_button_view.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultPage extends ConsumerWidget {
  ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: const SizedBox(),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: Text(
              localizations.appBarTitleQuizResult,
              style: TextTheme.of(context).headlineSmall,
            ),
          ),
        ),
        actions: const [
          // Dropdown Menu for Profile/Settings/Logout
          ProfileButtonView(),
          SizedBox(width: 16),
        ],
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
                child: Assets.images.dashLogo.image(width: 350, height: 350),
              ),
              const SizedBox(height: 20),
              Text(
                'Results coming soon . . .',
                style: TextTheme.of(context).displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
