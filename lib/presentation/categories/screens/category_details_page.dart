import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/widgets/dash_evolution_progress_dircle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('CategoryDetailsPage');

class CategoryDetailsPage extends ConsumerWidget {
  const CategoryDetailsPage({
    super.key,
    required this.category,
  });

  final Category? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // If no category is selected, show an error message
    if (category == null) {
      return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              languageCode == 'de' ? 'Kategoriedetails' : 'Category Details',
            ),
          ),
        ),
        body: const NoDataAvailableView(
          text: '❌ No category selected. Please go back and select a category.',
        ),
      );
    }

    // Extract localized strings for category details
    final String name =
        languageCode == 'de' ? category!.nameDe : category!.nameEn;
    final String description = languageCode == 'de'
        ? category!.descriptionDe
        : category!.descriptionEn;
    final String subtitle =
        languageCode == 'de' ? category!.subtitleDe : category!.subtitleEn;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // Reset the selected category when navigating back
        ref
            .read(selectedCategoryNotifierProvider.notifier)
            .selectCategory(null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 24),
                    DashEvolutionProgressCircleView(
                      progress: category!.progress,
                      size: 180,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Fixed button at the bottom
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: LightDarkSwitchBtn(
                  title: localizations.catgoryBtnLbl,
                  isActive: true,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/categories/details/topics',
                      arguments: category?.id,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
