import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/component_widgets/dash_evolution_progress_dircle_view.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';

Logger logger = Logger('CategoryDetailsPage');

class CategoryDetailsPage extends ConsumerWidget {
  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final categoryAsync =
        ref.watch(categoryByIdProvider(categoryId, languageCode));

    return Scaffold(
      // AppBar title can only be set once data is loaded
      appBar: BackNavAppBar(
        // Set title dynamically or use a generic one until data arrives
        title: categoryAsync.maybeWhen(
          data: (category) =>
              languageCode == 'de' ? category.nameDe : category.nameEn,
          orElse: () => localizations.categoryDetailsTitle,
        ),
        onBack: () {
          // Ensure we navigate back to the categories overview correctly
          if (context.canPop()) {
            context.pop();
          } else {
            // Fallback if cannot pop (e.g., deep link)
            context.goNamed(AppRouteNames.categories);
          }
        },
      ),
      // --- USE .when FOR THE BODY ---
      body: categoryAsync.when(
        data: (category) {
          // Data is loaded, build the UI using the fetched 'category' object
          final user = ref.watch(currentUserModelProvider).valueOrNull;
          // Use the categoryId from the constructor for progress
          final progress = user?.categoryProgress[categoryId] ?? 0.0;

          // Extract localized strings from the loaded 'category' object
          // No need for null checks here as 'category' is guaranteed by the 'data' callback
          final String description = languageCode == 'de'
              ? category.descriptionDe
              : category.descriptionEn;
          final String subtitle =
              languageCode == 'de' ? category.subtitleDe : category.subtitleEn;

          // Build the UI as before, using the loaded 'category' data
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 24),
                    DashEvolutionProgressCircleView(
                      progress: progress,
                      size: 180,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    AutoHyphenatingText(
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
                    context.pushNamed(
                      AppRouteNames.topics,
                      pathParameters: {'categoryId': categoryId},
                    );
                  },
                ),
              ),
            ],
          );
        },
        // Show a loading indicator while fetching data
        loading: () => const Center(child: CircularProgressIndicator()),
        // Show an error message if fetching fails
        error: (error, stack) {
          logger.severe(
              'Error loading category $categoryId: $error', error, stack);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                // Use a localization key for the error message
                '${localizations.categoryDetailsErrorLoading}\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
