// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'BrainBench';

  @override
  String get bottomNavigationHome => 'Home';

  @override
  String get bottomNavigationQuiz => 'Quiz';

  @override
  String get bottomNavigationResults => 'Ergebnisse';

  @override
  String get appBarTitleHome => 'BrainBench';

  @override
  String get appBarTitleCategories => 'Kategorien';

  @override
  String get appBarTitleQuizResult => 'Ergebnisse';

  @override
  String get chooseCategoryBtnLbl => 'Kategorie wählen';

  @override
  String get catgoryBtnLbl => 'Ok';

  @override
  String get startQuizBtnLbl => 'Quiz starten';

  @override
  String get quizAppBarTitle => 'Quiz';

  @override
  String get submitAnswerBtnLbl => 'Fertig';

  @override
  String get nextQuestionBtnLbl => 'Nächste Frage';

  @override
  String get finishQuizBtnLbl => 'Quiz beenden';

  @override
  String get quizCompletedMsg => '🎉 Quiz abgeschlossen';

  @override
  String get feedBackBottomSheetTitle => 'Ergebnisse';

  @override
  String get feedbackBSheetCorrectAnswers => 'Korrekte Antworten:';

  @override
  String get feedbackBSheetWrongAnswers => 'Falsche Antworten:';

  @override
  String get feedbackBSheetMissedCorrectAnswers => 'Verpasste korrekte Antworten:';

  @override
  String get quizResultsAppBarTitle => 'Quiz Ergebnisse';

  @override
  String get quizResultsNotSaved => 'Keine Quiz Ergebnisse gespeichert';

  @override
  String get answerExpandableQuestionHeader => 'Frage:';

  @override
  String get answerExpandableExplanationHeader => 'Erklärung:';

  @override
  String get answerExpandableNoExplanation => 'Keine Erklärung verfügbar';

  @override
  String get quizToggleExplanation => 'Hier kannst du zwischen deinen richtigen und falschen Antworten filtern. Tippe dafür auf die Daumen!';
}
