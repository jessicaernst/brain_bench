import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CarouselCardContent extends StatelessWidget {
  const CarouselCardContent({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(isActive ? 14.5 : 11.33),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Assets.appIcons.evo4.image(
              height: isActive ? 153 : 117,
              width: isActive ? 228 : 151,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text('title'),
        Text('content'),
      ],
    );
  }
}
