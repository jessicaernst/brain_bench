import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/back_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
import 'package:brain_bench/core/shared_widgets/progress_bars/dash_evolution_progress_dircle_view.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('CategoryDetailsPage');

class CategoryDetailsPage extends ConsumerWidget {
  const CategoryDetailsPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final categoryAsync = ref.watch(
      categoryByIdProvider(categoryId, languageCode),
    );

    return Scaffold(
      appBar: BackNavAppBar(
        title: categoryAsync.maybeWhen(
          data:
              (category) =>
                  languageCode == 'de' ? category.nameDe : category.nameEn,
          orElse: () => localizations.categoryDetailsTitle,
        ),
        onBack: () {
          ref
              .read(selectedCategoryNotifierProvider.notifier)
              .selectCategory(null);
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(AppRouteNames.categories);
          }
        },
      ),
      body: categoryAsync.when(
        data: (category) {
          final userState = ref.watch(currentUserModelProvider);

          final progress = userState.when(
            data:
                (state) => switch (state) {
                  UserModelData(:final user) =>
                    user.categoryProgress[categoryId] ?? 0.0,
                  _ => 0.0,
                },
            loading: () => 0.0,
            error: (_, __) => 0.0,
          );

          final String description =
              languageCode == 'de'
                  ? category.descriptionDe
                  : category.descriptionEn;
          final String subtitle =
              languageCode == 'de' ? category.subtitleDe : category.subtitleEn;

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          logger.severe(
            'Error loading category $categoryId: $error',
            error,
            stack,
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
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
