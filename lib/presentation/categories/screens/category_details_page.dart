import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/presentation/categories/widgets/category_button.dart';
import 'package:brain_bench/presentation/categories/widgets/progress_evolution_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryDetailsPage extends ConsumerWidget {
  const CategoryDetailsPage({
    super.key,
    required this.category,
  });

  final Category? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (category == null) {
      return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                languageCode == 'de' ? 'Kategoriedetails' : 'Category Details'),
          ),
        ),
        body: Center(
          child: Text(
            languageCode == 'de'
                ? 'Keine Kategorie ausgewählt. Bitte gehen Sie zurück und wählen Sie eine Kategorie aus.'
                : 'No category selected. Please go back and select a category.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final String name =
        languageCode == 'de' ? category!.nameDe : category!.nameEn;
    final String description = languageCode == 'de'
        ? category!.descriptionDe
        : category!.descriptionEn;
    final String subtitle =
        languageCode == 'de' ? category!.subtitleDe : category!.subtitleEn;

    return PopScope(
      onPopInvokedWithResult: (popAction, result) {
        ref
            .read(selectedCategoryNotifierProvider.notifier)
            .selectCategory(null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              ProgessEvolutionImageView(
                progress: category!.progress,
                size: 200,
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CategoryButton(
                  title: 'Ok',
                  isActive: true,
                  isDarkMode: isDarkMode,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
