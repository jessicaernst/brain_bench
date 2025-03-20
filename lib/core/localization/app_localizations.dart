import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'BrainBench'**
  String get appTitle;

  /// The title of the home page in the bottom navigation bar
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavigationHome;

  /// The title of the quiz page in the bottom navigation bar
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get bottomNavigationQuiz;

  /// The title of the results page in the bottom navigation bar
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get bottomNavigationResults;

  /// The title of the home page in the app bar
  ///
  /// In en, this message translates to:
  /// **'BrainBench'**
  String get appBarTitleHome;

  /// The title of the categories page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get appBarTitleCategories;

  /// The title of the quiz result page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get appBarTitleQuizResult;

  /// The label of the button to choose a category
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategoryBtnLbl;

  /// The label of the button to choose a category
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get catgoryBtnLbl;

  /// The label of the button to start the quiz
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuizBtnLbl;

  /// The title of the quiz page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizAppBarTitle;

  /// The label of the button to submit an answer
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get submitAnswerBtnLbl;

  /// The label of the button to go to the next question
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestionBtnLbl;

  /// The label of the button to finish the quiz
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get finishQuizBtnLbl;

  /// The message displayed when the quiz is completed
  ///
  /// In en, this message translates to:
  /// **'🎉 Quiz Completed'**
  String get quizCompletedMsg;

  /// The title of the bottom sheet that displays the quiz results
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get feedBackBottomSheetTitle;

  /// The label for the correct answers in the quiz results bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Correct Answers:'**
  String get feedbackBSheetCorrectAnswers;

  /// The label for the incorrect answers in the quiz results bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Incorrect Answers:'**
  String get feedbackBSheetWrongAnswers;

  /// The label for the missed correct answers in the quiz results bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Missed Correct Answers:'**
  String get feedbackBSheetMissedCorrectAnswers;

  /// The title of the quiz results page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResultsAppBarTitle;

  /// The message displayed when the quiz results are not saved
  ///
  /// In en, this message translates to:
  /// **'Quiz results not saved'**
  String get quizResultsNotSaved;

  /// The header of the expandable question in the answer page
  ///
  /// In en, this message translates to:
  /// **'Question:'**
  String get answerExpandableQuestionHeader;

  /// The header of the expandable explanation in the answer page
  ///
  /// In en, this message translates to:
  /// **'Explanation:'**
  String get answerExpandableExplanationHeader;

  /// The message displayed when there is no explanation available
  ///
  /// In en, this message translates to:
  /// **'No explanation available'**
  String get answerExpandableNoExplanation;

  /// The label for the toggle explanation button
  ///
  /// In en, this message translates to:
  /// **'Here you can view the correct and incorrect answers along with explanations. Tap on the thumbs to do so!'**
  String get quizToggleExplanation;

  /// The label of the button to view the quiz results
  ///
  /// In en, this message translates to:
  /// **'Back to topic selection'**
  String get quizResultBtnLbl;

  /// The label for the passed quiz result
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get quizResultPassed;

  /// The label for the failed quiz result
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get quizResultFailed;

  /// The label for the quiz result score
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get quizResultScore;

  /// The label for the done topics
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get topicsDone;

  /// The title of the topics page
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicsTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
