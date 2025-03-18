// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BrainBench';

  @override
  String get bottomNavigationHome => 'Home';

  @override
  String get bottomNavigationQuiz => 'Quiz';

  @override
  String get bottomNavigationResults => 'Results';

  @override
  String get appBarTitleHome => 'BrainBench';

  @override
  String get appBarTitleCategories => 'Categories';

  @override
  String get appBarTitleQuizResult => 'Results';

  @override
  String get chooseCategoryBtnLbl => 'Choose Category';

  @override
  String get catgoryBtnLbl => 'Ok';

  @override
  String get startQuizBtnLbl => 'Start Quiz';

  @override
  String get quizAppBarTitle => 'Quiz';

  @override
  String get submitAnswerBtnLbl => 'Done';

  @override
  String get nextQuestionBtnLbl => 'Next Question';

  @override
  String get finishQuizBtnLbl => 'Finish Quiz';

  @override
  String get quizCompletedMsg => '🎉 Quiz Completed';

  @override
  String get feedBackBottomSheetTitle => 'Results';

  @override
  String get feedbackBSheetCorrectAnswers => 'Correct Answers:';

  @override
  String get feedbackBSheetWrongAnswers => 'Incorrect Answers:';

  @override
  String get feedbackBSheetMissedCorrectAnswers => 'Missed Correct Answers:';

  @override
  String get quizResultsAppBarTitle => 'Quiz Results';

  @override
  String get quizResultsNotSaved => 'Quiz results not saved';

  @override
  String get answerExpandableQuestionHeader => 'Question:';

  @override
  String get answerExpandableExplanationHeader => 'Explanation:';

  @override
  String get answerExpandableNoExplanation => 'No explanation available';

  @override
  String get quizToggleExplanation => 'Here you can view the correct and incorrect answers along with explanations. Tap on the thumbs to do so!';
}
