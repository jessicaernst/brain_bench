import 'package:brain_bench/presentation/home/screens/carousel_card_content.dart';
import 'package:brain_bench/presentation/home/widgets/active_news_carousel_card.dart';
import 'package:brain_bench/presentation/home/widgets/inactive_news_carousel_card.dart';
import 'package:flutter/material.dart';

/// A carousel widget that displays news cards.
class NewsCarousel extends StatefulWidget {
  const NewsCarousel({super.key});

  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  final PageController _controller = PageController(viewportFraction: 1.0);
  double currentPage = 0.0;

  final double cardWidth = 228.0;
  final double cardHeight = 347.0;
  final double inactiveScale = 0.92;
  final double spacing = 40.0;
  final int itemCount = 5;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    /// Sorts the indices based on their distance from the current page.
    ///
    /// The [itemCount] parameter represents the total number of items.
    /// The [currentPage] parameter represents the current page index.
    /// The function returns a list of sorted indices.
    final List<int> sortedIndices = List.generate(itemCount, (i) => i)
      ..sort((a, b) {
        final aDelta = (a - currentPage).abs();
        final bDelta = (b - currentPage).abs();

        if ((a - currentPage).round() == 0) return 1;
        if ((b - currentPage).round() == 0) return -1;

        return aDelta.compareTo(bDelta);
      });

    return SizedBox(
      height: cardHeight + 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final index in sortedIndices)
            _buildCard(context, index, screenWidth),
          IgnorePointer(
            ignoring: false,
            child: PageView.builder(
              controller: _controller,
              itemCount: itemCount,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a news card based on the given index.
  ///
  /// The [context] parameter is the build context.
  /// The [index] parameter is the index of the news card.
  /// The [screenWidth] parameter is the width of the screen.
  ///
  /// Returns a [Widget] representing the news card.
  Widget _buildCard(BuildContext context, int index, double screenWidth) {
    final double delta = index - currentPage;
    final bool isActive = delta.abs() < 0.5;

    final double scale = isActive ? 1.0 : inactiveScale;
    final double effectiveCardHeight =
        isActive ? cardHeight : cardHeight * inactiveScale;
    final double verticalOffset = (cardHeight - effectiveCardHeight) / 2;

    final double overlapFactor = 60.0;
    final double leftOffset = screenWidth / 2 -
        cardWidth / 2 +
        (delta > 0
            ? delta * (cardWidth - overlapFactor)
            : delta * (cardWidth - overlapFactor * 1.6));

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
              ? ActiveNewsCarouselCard(
                  content: CarouselCardContent(isActive: true),
                )
              : InactiveNewsCarouselCard(
                  content: CarouselCardContent(isActive: false),
                ),
        ),
      ),
    );
  }
}
