import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/component_widgets/dash_evolution_progress_dircle_view.dart';
import 'package:brain_bench/core/component_widgets/profile_button_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/home/carousel.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/presentation/home/widgets/news_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseTitleStyle = Theme.of(context).textTheme.displaySmall;

    final lightModeShadow = [
      Shadow(
        color: BrainBenchColors.deepDive.withAlpha((0.8 * 255).toInt()),
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
      ),
    ];

    final List<Carousel> carouselItems = [
      Carousel.create(
        title: 'Mastering UI: Image 12',
        description:
            'Learn how to structure layouts using advanced Figma UI blocks.',
        imageUrl: Assets.carouselTest.image12.path,
      ),
      Carousel.create(
        title: 'Design Systems: Image 13',
        description:
            'Understand how to build scalable and reusable design systems.',
        imageUrl: Assets.carouselTest.image13.path,
      ),
      Carousel.create(
        title: 'Typography Tricks: Image 14',
        description:
            'Typography techniques to improve readability and design harmony.',
        imageUrl: Assets.carouselTest.image14.path,
      ),
      Carousel.create(
        title: 'Modern Layouts: Image 15',
        description:
            'Explore advanced layout techniques with grids and spacing.',
        imageUrl: Assets.carouselTest.image15.path,
      ),
      Carousel.create(
        title: 'Component-Based UI: Image 16',
        description:
            'Discover how to build component-driven interfaces in Figma.',
        imageUrl: Assets.carouselTest.image16.path,
      ),
      Carousel.create(
        title: 'Figma Intro: Image',
        description:
            'Start designing mobile apps with a beginner-friendly mockup.',
        imageUrl: Assets.carouselTest.image.path,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: const SizedBox(),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: Text(
              localizations.appBarTitleHome,
              style: baseTitleStyle?.copyWith(
                color: BrainBenchColors.logoGold,
                shadows: isDarkMode ? null : lightModeShadow,
              ),
            ),
          ),
        ),
        actions: const [
          ProfileButtonView(),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'actual',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? BrainBenchColors.cloudCanvas
                                  .withAlpha((0.6 * 255).toInt())
                              : BrainBenchColors.deepDive
                                  .withAlpha((0.6 * 255).toInt()),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DashEvolutionProgressCircleView(
                      progress: 0.75,
                      size: 118,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'test category',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 12),
                          AutoHyphenatingText(
                            'Potter ipsum wand elf parchment wingardium. Heir long description that needs to wrap automatically when space runs out.',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              NewsCarousel(items: carouselItems),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
