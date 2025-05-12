import 'package:brain_bench/data/models/quiz/question.dart';

extension LocalizedQuestion on Question {
  String localizedQuestion(String languageCode) {
    return languageCode == 'de' ? (questionDe ?? questionEn) : questionEn;
  }

  String? localizedExplanation(String languageCode) {
    return languageCode == 'de'
        ? (explanationDe ?? explanationEn)
        : explanationEn;
  }
}
