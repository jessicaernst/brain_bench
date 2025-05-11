import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/profile_button_view.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/articles/article_providers.dart';
import 'package:brain_bench/data/models/home/article.dart';
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

    final articlesAsync = ref.watch(articlesProvider);

    List<Article> itemsForArticle;

    if (articlesAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articlesAsync is AsyncError) {
      return Center(child: Text(localizations.articleLoadingError));
    }

    final articleItems = articlesAsync.value ?? [];

    final List<Article> baseArticlesForSelection =
        (selectedCategoryId == null)
            ? articleItems
            : articleItems
                .where((item) => item.categoryId == selectedCategoryId)
                .toList();

    if (baseArticlesForSelection.isNotEmpty) {
      itemsForArticle = List.from(baseArticlesForSelection)..shuffle();
    } else {
      itemsForArticle = List.from(
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
                      itemsForArticle.map((item) {
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
