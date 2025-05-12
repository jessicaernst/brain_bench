import 'package:brain_bench/data/models/topic/topic.dart';

extension LocalizedTopic on Topic {
  String localizedName(String languageCode) {
    return languageCode == 'de' ? (nameDe ?? nameEn) : nameEn;
  }

  String localizedDescription(String languageCode) {
    return languageCode == 'de'
        ? (descriptionDe ?? descriptionEn)
        : descriptionEn;
  }
}
