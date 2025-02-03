import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/presentation/categories/widgets/category_button.dart';
import 'package:brain_bench/presentation/categories/widgets/progress_evolution_image_view.dart';
import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({
    super.key,
    required this.category,
  });

  final Category? category;

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final category = ModalRoute.of(context)?.settings.arguments as Category?;
    if (category == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              languageCode == 'de' ? 'Kategoriedetails' : 'Category Details'),
        ),
        body: Center(
          child: Text(
            languageCode == 'de'
                ? 'Keine Kategorie ausgewählt. Bitte gehen Sie zurück und wählen Sie eine Kategorie aus.'
                : 'No category selected. Please go back and select a category.',
          ),
        ),
      );
    }

    final String name =
        languageCode == 'de' ? category.nameDe : category.nameEn;
    final String description =
        languageCode == 'de' ? category.descriptionDe : category.descriptionEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            ProgessEvolutionImageView(
              progress: category.progress,
              size: 150,
            ),
            const SizedBox(height: 48),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CategoryButton(
                title: 'title',
                isActive: true,
                isDarkMode: isDarkMode,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
