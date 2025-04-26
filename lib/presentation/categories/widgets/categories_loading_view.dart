import 'package:brain_bench/core/component_widgets/profile_button_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoriesLoadingView extends StatelessWidget {
  const CategoriesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: const SizedBox(),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.appBarTitleCategories,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        actions: const [
          Opacity(
            opacity: 0.5,
            child: IgnorePointer(
              // Prevent interactions
              child: ProfileButtonView(),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
