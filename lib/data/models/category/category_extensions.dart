import 'package:brain_bench/data/models/category/category.dart';

extension LocalizedCategory on Category {
  String localizedName(String languageCode) {
    return languageCode == 'de' ? (nameDe ?? nameEn) : nameEn;
  }

  String localizedSubtitle(String languageCode) {
    return languageCode == 'de' ? (subtitleDe ?? subtitleEn) : subtitleEn;
  }

  String localizedDescription(String languageCode) {
    return languageCode == 'de'
        ? (descriptionDe ?? descriptionEn)
        : descriptionEn;
  }
}
