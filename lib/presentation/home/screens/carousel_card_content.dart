import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/data/models/home/carousel.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content of a carousel card.
class CarouselCardContent extends StatelessWidget {
  const CarouselCardContent({
    super.key,
    required this.isActive,
    required this.item,
  });

  final bool isActive;
  final Carousel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isActive ? 14.5 : 11.33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              item.imageUrl,
              height: isActive ? 153 : 117,
              width: isActive ? 228 : 151,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          AutoHyphenatingText(
            item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: isActive ? 15 : 12,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          AutoHyphenatingText(
            item.description,
            overflow: TextOverflow.ellipsis,
            maxLines: isActive ? 3 : 4,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isActive ? 15 : 12,
                ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  debugPrint('Button tapped: ${item.title}');
                },
                child: const Text('tap for more'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
