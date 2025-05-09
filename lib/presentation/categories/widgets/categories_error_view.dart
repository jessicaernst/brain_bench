import 'package:brain_bench/core/shared_widgets/buttons/profile_button_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoriesErrorView extends StatelessWidget {
  final Object error;
  const CategoriesErrorView({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
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
            // Prevents touch events
            child: IgnorePointer(child: ProfileButtonView()),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${AppLocalizations.of(context)!.errorGeneric}: $error'),
        ),
      ),
    );
  }
}
