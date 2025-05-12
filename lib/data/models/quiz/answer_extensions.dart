import 'package:brain_bench/data/models/quiz/answer.dart';

extension LocalizedAnswer on Answer {
  String localizedText(String languageCode) {
    return languageCode == 'de' ? (textDe ?? textEn) : textEn;
  }
}
