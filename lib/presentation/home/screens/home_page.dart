import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/business_logic/profile/profile_ui_state_providers.dart';
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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('HomePage');

/// The home page widget that displays a carousel of articles.
class HomePage extends HookConsumerWidget {
  HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String? selectedCategoryId = ref.watch(selectedHomeCategoryProvider);
    final int activeIndexFromProvider = ref.watch(activeCarouselIndexProvider);

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

    final articlesAsync = ref.watch(shuffledArticlesProvider);

    // Effect to listen for changes in the selected category. Runs once on mount.
    useEffect(() {
      final subscription = ref.listenManual<
        String?
      >(selectedHomeCategoryProvider, (previous, next) {
        if (previous != null && previous != next) {
          _logger.fine(
            'Category actively changed from "$previous" to "$next". Resetting active carousel index to 0.',
          );
          ref.read(activeCarouselIndexProvider.notifier).update(0);
        }
      });
      // Cleanup the listener
      return subscription.close;
    }, const []);

    // Listener for the Snackbar-Provider to show contact image auto-save notification
    ref.listen<bool>(showContactImageAutoSaveSnackbarProvider, (
      bool? previous, // previous can be null on first listen
      next,
    ) {
      if (next == true) {
        // Ensure context is still valid if this runs delayed
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.profileContactImageAutoSaved,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              duration: const Duration(seconds: 4),
              backgroundColor: BrainBenchColors.correctAnswerGlass,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
          // Reset the provider so the snackbar doesn't re-trigger on rebuilds
          // Doing this in a post-frame callback is safer to avoid modifying state
          // during a build or notification phase.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ref.read(showContactImageAutoSaveSnackbarProvider)) {
              // Check if still true before resetting
              ref
                  .read(showContactImageAutoSaveSnackbarProvider.notifier)
                  .reset();
            }
          });
        }
      }
    });

    // Effect to listen for changes in the selected category from SharedPreferences
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
      itemsForArticle = List.from(baseArticlesForSelection);
    } else {
      itemsForArticle = List.from(
        articleItems.where((item) => item.categoryId == 'welcome'),
      );
    }

    // Ensure the activeIndexFromProvider is valid for the current itemsForArticle list
    final bool isValidInitialItem =
        itemsForArticle.isNotEmpty &&
        activeIndexFromProvider >= 0 &&
        activeIndexFromProvider < itemsForArticle.length;

    int actualInitialItem;
    if (isValidInitialItem) {
      actualInitialItem = activeIndexFromProvider;
    } else {
      if (itemsForArticle.isNotEmpty) {
        _logger.warning(
          'Warning: activeIndexFromProvider ($activeIndexFromProvider) is out of bounds for itemsForArticle (length: ${itemsForArticle.length}). Falling back to 0.',
        );
      }
      actualInitialItem = 0; // Fallback to 0
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
                  localizations.carouselArticleTitle,
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
                child:
                    itemsForArticle.isNotEmpty
                        ? InfiniteCarousel(
                          key: ValueKey(
                            selectedCategoryId ?? 'all_articles_carousel',
                          ),
                          items:
                              itemsForArticle.map((item) {
                                return InfiniteCarouselItem(
                                  content: CarouselCardContent(
                                    item: item,
                                    isActive:
                                        false, // isActive is handled by active/inactive builders
                                  ),
                                );
                              }).toList(),
                          initialItem: actualInitialItem,
                          onActiveItemChanged: (index) {
                            final String? categoryIdWhenCarouselWasBuilt =
                                selectedCategoryId;
                            // Check if the widget is still mounted before trying to read/update providers
                            // For HookConsumerWidget, we don't have a direct 'mounted' property like in State.
                            // However, the callback itself will only be active as long as the widget is in the tree.
                            // The Future.microtask helps deferring the provider update slightly.
                            if (index >= 0 && index < itemsForArticle.length) {
                              Future.microtask(() {
                                // Check if the category context for this callback is still the active one
                                final String? currentActiveCategoryInApp = ref
                                    .read(selectedHomeCategoryProvider);
                                if (categoryIdWhenCarouselWasBuilt ==
                                    currentActiveCategoryInApp) {
                                  ref
                                      .read(
                                        activeCarouselIndexProvider.notifier,
                                      )
                                      .update(index);
                                } else {
                                  _logger.fine(
                                    'Carousel callback for stale category ($categoryIdWhenCarouselWasBuilt) ignored. Current is ($currentActiveCategoryInApp). Index: $index',
                                  );
                                }
                              });
                            } else {
                              _logger.warning(
                                'InfiniteCarousel reported out-of-bounds index: $index for category $categoryIdWhenCarouselWasBuilt. Max items: ${itemsForArticle.length}',
                              );
                            }
                          },
                          cardWidth: carouselCardWidth,
                          cardHeight: carouselCardHeight,
                          activeCardBuilder:
                              (child) => ActiveNewsCarouselCard(content: child),
                          inactiveCardBuilder:
                              (child) =>
                                  InactiveNewsCarouselCard(content: child),
                          animationDuration: const Duration(milliseconds: 200),
                          animationCurve: Curves.easeOut,
                        )
                        : Center(
                          child: Text(localizations.noArticlesAvailable),
                        ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
