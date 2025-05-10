import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/profile_button_view.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/home/carousel.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:brain_bench/presentation/home/widgets/active_news_carousel_card.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_view.dart';
import 'package:brain_bench/presentation/home/widgets/carousel_card_content.dart';
import 'package:brain_bench/presentation/home/widgets/inactive_news_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

/// The home page widget that displays a carousel of articles.
class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String? selectedCategoryId = ref.watch(selectedHomeCategoryProvider);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bool isSmallScreenValue = context.isSmallScreen;

    final double carouselCardHeight = isSmallScreenValue ? 300 : 347;
    final double carouselCardWidth = isSmallScreenValue ? 197 : 228;
    final baseTitleStyle = Theme.of(context).textTheme.displaySmall;

    final lightModeShadow = [
      Shadow(
        color: BrainBenchColors.deepDive.withAlpha((0.8 * 255).toInt()),
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
      ),
    ];

    final double appBarTitleSize =
        isSmallScreenValue ? 28 : (baseTitleStyle?.fontSize ?? 36);

    final List<Carousel> articleItems = [
      Carousel.create(
        title: 'Mastering UI: Image 12',
        description:
            'Learn how to structure layouts using advanced Figma UI blocks.',
        imageUrl: Assets.carouselTest.image12.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Design Systems: Image 13',
        description:
            'Understand how to build scalable and reusable design systems.',
        imageUrl: Assets.carouselTest.image13.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Typography Tricks: Image 14',
        description:
            'Typography techniques to improve readability and design harmony.',
        imageUrl: Assets.carouselTest.image14.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Modern Layouts: Image 15',
        description:
            'Explore advanced layout techniques with grids and spacing.',
        imageUrl: Assets.carouselTest.image15.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Component-Based UI: Image 16',
        description:
            'Discover how to build component-driven interfaces in Figma.',
        imageUrl: Assets.carouselTest.image16.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Figma Intro: Image',
        description:
            'Start designing mobile apps with a beginner-friendly mockup. Start designing mobile apps with a beginner-friendly mockup. Start designing mobile apps with a beginner-friendly mockup.',
        imageUrl: Assets.carouselTest.image.path,
        categoryId: '2b3c4d5e-design-002',
      ),
      Carousel.create(
        title: 'Ecosystem - Intro Module',
        description: 'A great place to get started with this topic.',
        imageUrl: Assets.carouselTest.image12.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Ecosystem - Fundamentals',
        description: 'Understand the essential principles and concepts.',
        imageUrl: Assets.carouselTest.image13.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Ecosystem - Core Techniques',
        description: 'Learn practical approaches and best practices.',
        imageUrl: Assets.carouselTest.image14.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Ecosystem - Advanced Concepts',
        description: 'Explore more complex techniques and patterns.',
        imageUrl: Assets.carouselTest.image15.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Ecosystem - Applied Learning',
        description: 'See how the concepts work in real-world examples.',
        imageUrl: Assets.carouselTest.image16.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Ecosystem - Quick Start',
        description: 'Jump right in with a guided example.',
        imageUrl: Assets.carouselTest.image.path,
        categoryId: '1a2b3c4d-ecosystem-001',
      ),
      Carousel.create(
        title: 'Coding - Intro Module',
        description: 'A great place to get started with this topic.',
        imageUrl: Assets.carouselTest.image12.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Coding - Fundamentals',
        description: 'Understand the essential principles and concepts.',
        imageUrl: Assets.carouselTest.image13.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Coding - Core Techniques',
        description: 'Learn practical approaches and best practices.',
        imageUrl: Assets.carouselTest.image14.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Coding - Advanced Concepts',
        description: 'Explore more complex techniques and patterns.',
        imageUrl: Assets.carouselTest.image15.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Coding - Applied Learning',
        description: 'See how the concepts work in real-world examples.',
        imageUrl: Assets.carouselTest.image16.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Coding - Quick Start',
        description: 'Jump right in with a guided example.',
        imageUrl: Assets.carouselTest.image.path,
        categoryId: 'f711e799-3ebe-46d3-9d78-722e2d024cec',
      ),
      Carousel.create(
        title: 'Flutter - Intro Module',
        description: 'A great place to get started with this topic.',
        imageUrl: Assets.carouselTest.image12.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Flutter - Fundamentals',
        description: 'Understand the essential principles and concepts.',
        imageUrl: Assets.carouselTest.image13.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Flutter - Core Techniques',
        description: 'Learn practical approaches and best practices.',
        imageUrl: Assets.carouselTest.image14.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Flutter - Advanced Concepts',
        description: 'Explore more complex techniques and patterns.',
        imageUrl: Assets.carouselTest.image15.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Flutter - Applied Learning',
        description: 'See how the concepts work in real-world examples.',
        imageUrl: Assets.carouselTest.image16.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Flutter - Quick Start',
        description: 'Jump right in with a guided example.',
        imageUrl: Assets.carouselTest.image.path,
        categoryId: '3c4d5e6f-flutter-003',
      ),
      Carousel.create(
        title: 'Welcome - Getting Started',
        description:
            'Learn how BrainBench works and what to expect from your quiz journey.',
        imageUrl: Assets.carouselTest.image12.path,
        categoryId: 'welcome',
      ),
      Carousel.create(
        title: 'Welcome - Your First Quiz',
        description:
            'Get ready for your first quiz – we’ll guide you through each step.',
        imageUrl: Assets.carouselTest.image13.path,
        categoryId: 'welcome',
      ),
      Carousel.create(
        title: 'Welcome - Categories & Topics',
        description:
            'Discover how content is structured into categories and topics.',
        imageUrl: Assets.carouselTest.image14.path,
        categoryId: 'welcome',
      ),
      Carousel.create(
        title: 'Welcome - Progress Tracking',
        description:
            'See how your progress is saved and visualized across all topics.',
        imageUrl: Assets.carouselTest.image15.path,
        categoryId: 'welcome',
      ),
      Carousel.create(
        title: 'Welcome - Earning Results',
        description:
            'Understand how results are calculated and how to improve over time.',
        imageUrl: Assets.carouselTest.image16.path,
        categoryId: 'welcome',
      ),
      Carousel.create(
        title: 'Welcome - Customize Your Learning',
        description:
            'Explore how to switch themes, languages and pick what to focus on.',
        imageUrl: Assets.carouselTest.image.path,
        categoryId: 'welcome',
      ),
    ];

    List<Carousel> itemsForCarousel;

    final List<Carousel> baseArticlesForSelection =
        (selectedCategoryId == null)
            ? articleItems
            : articleItems
                .where((item) => item.categoryId == selectedCategoryId)
                .toList();

    if (baseArticlesForSelection.isNotEmpty) {
      itemsForCarousel = List.from(baseArticlesForSelection)..shuffle();
    } else {
      itemsForCarousel = List.from(
        articleItems.where((item) => item.categoryId == 'welcome'),
      )..shuffle();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          localizations.appBarTitleHome,
          style: baseTitleStyle?.copyWith(
            fontSize: appBarTitleSize,
            color: BrainBenchColors.logoGold,
            shadows: isDarkMode ? null : lightModeShadow,
          ),
        ),
        actions: const [ProfileButtonView(), SizedBox(width: 16)],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ActualCategoryView(isDarkMode: isDarkMode),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: isSmallScreenValue ? 16 : 32,
                ),
                child: Text(
                  'articles',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkMode
                            ? BrainBenchColors.cloudCanvas.withAlpha(
                              (0.6 * 255).toInt(),
                            )
                            : BrainBenchColors.deepDive.withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                  ),
                ),
              ),
              Expanded(
                child: InfiniteCarousel(
                  key: ValueKey(selectedCategoryId ?? 'all'),
                  items:
                      itemsForCarousel.map((item) {
                        // Verwende itemsForCarousel
                        return InfiniteCarouselItem(
                          content: CarouselCardContent(
                            item: item,
                            isActive: false,
                          ),
                        );
                      }).toList(),
                  cardWidth: carouselCardWidth,
                  cardHeight: carouselCardHeight,
                  activeCardBuilder:
                      (child) => ActiveNewsCarouselCard(content: child),
                  inactiveCardBuilder:
                      (child) => InactiveNewsCarouselCard(content: child),
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.easeOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
