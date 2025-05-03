import 'package:brain_bench/presentation/home/screens/carousel_card_content.dart';
import 'package:brain_bench/presentation/home/widgets/active_news_carousel_card.dart';
import 'package:brain_bench/presentation/home/widgets/inactive_news_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A carousel widget that displays news cards.
class NewsCarousel extends HookConsumerWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController(viewportFraction: 1.0);
    final currentPage = useState(0.0);

    useEffect(() {
      void listener() {
        currentPage.value = controller.page ?? 0.0;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    final double screenWidth = MediaQuery.of(context).size.width;
    const double cardWidth = 228.0;
    const double cardHeight = 347.0;
    const double inactiveScale = 0.9;
    const int itemCount = 5;

    final sortedIndices = List.generate(itemCount, (i) => i)
      ..sort((a, b) {
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
            itemCount: itemCount,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),
          for (final index in sortedIndices)
            _buildCard(
              context,
              index,
              screenWidth,
              currentPage.value,
              controller,
              cardWidth,
              cardHeight,
              inactiveScale,
            ),
        ],
      ),
    );
  }

  /// Builds a news card based on the provided parameters.
  Widget _buildCard(
    BuildContext context,
    int index,
    double screenWidth,
    double currentPage,
    PageController controller,
    double cardWidth,
    double cardHeight,
    double inactiveScale,
  ) {
    final double delta = index - currentPage;
    final bool isActive = delta.abs() < 0.5;
    final double scale = isActive ? 1.0 : inactiveScale;
    final double effectiveCardHeight = cardHeight * scale;
    final double verticalOffset = (cardHeight - effectiveCardHeight) / 2;
    final double overlapFactor = 60.0;
    final double leftOffset = screenWidth / 2 -
        cardWidth / 2 +
        (delta > 0
            ? delta * (cardWidth - overlapFactor)
            : delta * (cardWidth - overlapFactor * 1.6));

    final card = isActive
        ? ActiveNewsCarouselCard(
            content: CarouselCardContent(isActive: true),
          )
        : InactiveNewsCarouselCard(
            content: CarouselCardContent(isActive: false),
          );

    return Positioned(
      top: verticalOffset,
      left: leftOffset,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: SizedBox(
          width: isActive ? cardWidth : 174.1,
          height: effectiveCardHeight,
          child: isActive
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) {
                    controller.position.moveTo(
                      controller.position.pixels - details.delta.dx,
                    );
                  },
                  child: card,
                )
              : AbsorbPointer(
                  absorbing: true,
                  child: card,
                ),
        ),
      ),
    );
  }
}
