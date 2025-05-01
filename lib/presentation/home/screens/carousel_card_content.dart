import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CarouselCardContent extends StatelessWidget {
  const CarouselCardContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(14.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Assets.appIcons.evo4.image(
              height: 157,
              width: 220,
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
