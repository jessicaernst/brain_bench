import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/models/home/article.dart';
import 'package:brain_bench/data/models/home/article_extensions.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A widget that represents the content of a carousel card.
class CarouselCardContent extends StatelessWidget {
  const CarouselCardContent({
    super.key,
    required this.isActive,
    required this.item,
  });

  final bool isActive;
  final Article item;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;
    final bool isSmallScreenValue = context.isSmallScreen;
    final int descriptionMaxLines = isSmallScreenValue ? 2 : 4;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          SizedBox(height: isActive ? 14.5 : 11.33),
          AutoHyphenatingText(
            item.localizedTitle(languageCode),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          AutoHyphenatingText(
            item.localizedDescription(languageCode),
            overflow: TextOverflow.ellipsis,
            maxLines: descriptionMaxLines,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  context.pushNamed(
                    AppRouteNames.articleDetail,
                    pathParameters: {'articleId': item.id},
                  );
                },
                child: Text(
                  localizations.tapForMore,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        isDarkMode
                            ? BrainBenchColors.flutterSky
                            : BrainBenchColors.blueprintBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
