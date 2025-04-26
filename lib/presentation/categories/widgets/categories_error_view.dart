import 'package:brain_bench/core/component_widgets/profile_button_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoriesErrorView extends StatelessWidget {
  final Object error;
  const CategoriesErrorView({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    // Consistent Scaffold structure
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: const SizedBox(),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('${AppLocalizations.of(context)!.errorGeneric}: $error'),
      )),
    );
  }
}
