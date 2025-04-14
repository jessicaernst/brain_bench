import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({
    super.key,
    this.onBack,
    this.error,
  });

  final VoidCallback? onBack;
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final VoidCallback effectiveOnBack = onBack ??
        () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        };

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.notFoundAppBarTitle,
        onBack: effectiveOnBack,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.sadHam.image(
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 48),
              Text(
                localizations.notFoundHeading,
                style: TextTheme.of(context).headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 16),
                Text(
                  localizations.notFoundErrorDetailsLabel,
                  style: TextTheme.of(context).titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withAlpha((0.8 * 255).toInt()),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
