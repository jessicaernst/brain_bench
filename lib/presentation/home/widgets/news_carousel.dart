import 'package:brain_bench/data/models/home/carousel.dart';
import 'package:brain_bench/presentation/home/screens/carousel_card_content.dart';
import 'package:brain_bench/presentation/home/widgets/active_news_carousel_card.dart';
import 'package:brain_bench/presentation/home/widgets/inactive_news_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A carousel widget that displays news cards with infinite scrolling.
class NewsCarousel extends HookConsumerWidget {
  const NewsCarousel({super.key, required this.items});

  final List<Carousel> items;

  // Faktor für den "unendlichen" Bereich und Startseite
  static const int _infiniteScrollMultiplier = 1000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double cardWidth = 228.0;
    const double cardHeight = 347.0;
    const double inactiveScale = 0.9;

    final int initialPage =
        items.isNotEmpty ? (items.length * _infiniteScrollMultiplier ~/ 2) : 0;
    final controller =
        usePageController(viewportFraction: 1.0, initialPage: initialPage);
    final currentPage = useState<double>(initialPage.toDouble());

    useEffect(() {
      void listener() {
        if (controller.hasClients && controller.page != null) {
          currentPage.value = controller.page!;
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    final screenWidth = MediaQuery.of(context).size.width;

    if (items.isEmpty) {
      return SizedBox(height: cardHeight + 40);
    }

    final int currentNearestPage = currentPage.value.round();
    const int range = 1;
    final List<int> indicesToRender = [];
    for (int i = -range; i <= range; i++) {
      final pageIndex = currentNearestPage + i;
      if (pageIndex >= 0 &&
          pageIndex < items.length * _infiniteScrollMultiplier) {
        indicesToRender.add(pageIndex);
      }
    }

    indicesToRender.sort((a, b) {
      final aDelta = (a - currentPage.value).abs();
      final bDelta = (b - currentPage.value).abs();
      return bDelta.compareTo(aDelta);
    });

    return SizedBox(
      height: cardHeight + 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: items.length * _infiniteScrollMultiplier,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),
          for (final pageIndex in indicesToRender)
            _buildCard(
              context: context,
              pageIndex: pageIndex,
              screenWidth: screenWidth,
              currentPage: currentPage.value,
              controller: controller,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              inactiveScale: inactiveScale,
              item: items[
                  (pageIndex % items.length + items.length) % items.length],
            ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required int pageIndex,
    required double screenWidth,
    required double currentPage,
    required PageController controller,
    required double cardWidth,
    required double cardHeight,
    required double inactiveScale,
    required Carousel item,
  }) {
    final double delta = pageIndex - currentPage;
    final bool isActive = delta.abs() < 0.5;
    final double scale = isActive ? 1.0 : inactiveScale;
    final double effectiveCardHeight = cardHeight * scale;
    final double verticalOffset = (cardHeight - effectiveCardHeight) / 2;
    final double overlapFactor = 60.0;
    final double leftOffset = screenWidth / 2 -
        (cardWidth * scale) / 2 +
        (delta > 0
            ? delta * (cardWidth - overlapFactor)
            : delta * (cardWidth - overlapFactor * 1.6));

    final cardContent = CarouselCardContent(isActive: isActive, item: item);
    final Widget cardWidget = isActive
        ? ActiveNewsCarouselCard(content: cardContent)
        : InactiveNewsCarouselCard(content: cardContent);

    return Positioned(
      top: verticalOffset,
      left: leftOffset,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: SizedBox(
          width: cardWidth * scale,
          height: cardHeight * scale,
          child: isActive
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) {
                    if (controller.hasClients) {
                      controller.position.moveTo(
                        controller.position.pixels - details.delta.dx,
                        clamp: false,
                      );
                    }
                  },
                  onPanEnd: (_) {
                    if (controller.hasClients) {
                      final nearestPage = controller.page?.round() ?? 0;
                      controller.animateToPage(
                        nearestPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: cardWidget,
                )
              : AbsorbPointer(absorbing: true, child: cardWidget),
        ),
      ),
    );
  }
}
