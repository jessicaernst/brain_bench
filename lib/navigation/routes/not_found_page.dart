import 'package:brain_bench/core/widgets/back_nav_app_bar.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackNavAppBar(
        title: 'Page Not Found',
        onBack: onBack,
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
