import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content of a carousel card.
class CarouselCardContent extends StatelessWidget {
  const CarouselCardContent({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isActive ? 14.5 : 11.33),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Assets.carouselTest.image.image(
              height: isActive ? 153 : 117,
              width: isActive ? 228 : 151,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 6),
          AutoHyphenatingText(
            'Figma Basics: Designing Your First Mobile App Mockup',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: isActive ? 15 : 12,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          AutoHyphenatingText(
            'Learn how to start your journey in app design with our beginner’s guide to creating your first mobile app mockup in Figma.',
            overflow: TextOverflow.ellipsis,
            maxLines: isActive ? 1 : 2,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isActive ? 15 : 12,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  debugPrint('Button tapped');
                },
                child: Text('tap for more'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
