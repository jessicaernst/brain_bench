import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Page Not Found',
          style: TextTheme.of(context).headlineSmall,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 48,
          children: [
            Assets.images.sadHam.image(
              width: 200,
              height: 200,
            ),
            Text(
              '404 - Page Not Found',
              style: TextTheme.of(context).headlineMedium?.copyWith(
                    color: ColorScheme.of(context).error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
