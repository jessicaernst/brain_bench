import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/presentation/categories/widgets/categories_error_view.dart';
import 'package:brain_bench/presentation/categories/widgets/categories_loaded_view.dart';
import 'package:brain_bench/presentation/categories/widgets/categories_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

Logger _logger = Logger('CategoriesPage');

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;

    // Fetch categories using the provider
    final categoriesAsync = ref.watch(categoriesProvider(languageCode));

    // Build UI based on the state of categoriesAsync
    return categoriesAsync.when(
      data: (categories) {
        _logger.info('Categories data received. Total: ${categories.length}');
        // Pass data to the loaded view widget
        return CategoriesLoadedView(
          categories: categories,
          localizations: localizations,
          languageCode: languageCode,
        );
      },
      loading: () {
        _logger.info('Loading categories...');
        // Delegate to the loading view widget
        return const CategoriesLoadingView();
      },
      error: (error, stack) {
        _logger.severe('Error loading categories: $error', error, stack);
        // Delegate to the error view widget
        return CategoriesErrorView(error: error);
      },
    );
  }
}
