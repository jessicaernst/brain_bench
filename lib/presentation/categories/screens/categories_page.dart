import 'package:brain_bench/core/widgets/darkmode_btn.dart';
import 'package:brain_bench/core/widgets/lightmode_btn.dart';
import 'package:brain_bench/presentation/categories/widgets/progress_evolution_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appBarTitleCategories,
          style: TextTheme.of(context).headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 20,
            children: [
              const ProgessEvolutionImageView(
                size: 100,
                progress: 0.24,
              ),
              LightmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
              DarkmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
