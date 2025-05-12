import 'package:brain_bench/data/models/home/article.dart';

extension LocalizedArticle on Article {
  String localizedTitle(String languageCode) {
    return languageCode == 'de' ? (titleDe ?? titleEn) : titleEn;
  }

  String localizedDescription(String languageCode) {
    return languageCode == 'de'
        ? (descriptionDe ?? descriptionEn)
        : descriptionEn;
  }

  String localizedHtmlContent(String languageCode) {
    return languageCode == 'de'
        ? (htmlContentDe ?? htmlContentEn)
        : htmlContentEn;
  }
}
