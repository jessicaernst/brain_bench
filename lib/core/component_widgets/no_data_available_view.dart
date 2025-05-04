import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class NoDataAvailableView extends StatelessWidget {
  const NoDataAvailableView({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.sadHam.image(
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 56),
          Text(text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  )),
        ],
      ),
    );
  }
}
