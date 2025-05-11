import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/back_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/backgrounds/app_page_background.dart';
import 'package:brain_bench/data/infrastructure/articles/article_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A screen that displays the details of an article.
class ArticleDetailPage extends ConsumerWidget {
  final String articleId;

  /// Constructs an [ArticleDetailPage] with the given [articleId].
  const ArticleDetailPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleByIdProvider(articleId));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BackNavAppBar(
        title: articleAsync.when(
          data: (article) => article?.title ?? localizations.articleDetailTitle,
          loading: () => localizations.loading,
          error: (e, _) => localizations.articleDetailTitle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        onBack: () {
          context.pop();
        },
      ),
      body: Stack(
        children: [
          const AppPageBackground(),
          articleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (article) {
              if (article == null) {
                return Center(child: Text(localizations.articleNotFound));
              }

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: article.htmlContent,
                        style: {
                          'h1': Style(
                            fontSize: FontSize(32),
                            fontFamily: 'Urbanist',
                            color:
                                Theme.of(
                                  context,
                                ).textTheme.headlineLarge?.color,
                          ),
                          'body': Style(
                            fontSize: FontSize(16),
                            fontFamily: 'Urbanist',
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
