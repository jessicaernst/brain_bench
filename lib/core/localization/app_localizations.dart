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

  /// The header of the expandable question in the answer page
  ///
  /// In en, this message translates to:
  /// **'Question:'**
  String get answerExpandableQuestionHeader;

  /// The title of the categories page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get appBarTitleCategories;

  /// The title of the home page in the app bar
  ///
  /// In en, this message translates to:
  /// **'BrainBench'**
  String get appBarTitleHome;

  /// The title of the quiz result page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get appBarTitleQuizResult;

  /// The text of the divider
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get authDividerLoginText;

  /// The text of the divider
  ///
  /// In en, this message translates to:
  /// **'Or Sign in with'**
  String get authDividerRegisterText;

  /// The label for the email input field
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get authEmail;

  /// The error message displayed when the email input field is empty
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty.'**
  String get authEmailEmptyError;

  /// The error message displayed when the email input field is invalid
  ///
  /// In en, this message translates to:
  /// **'Email is invalid.'**
  String get authEmailInvalidError;

  /// The label of the login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginBtnLbl;

  /// The text of the login text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authLoginText;

  /// The label of the login text button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginTextBtnLbl;

  /// The title of the login page
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginTitle;

  /// The label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// The error message displayed when the password input field is empty
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get authPasswordEmptyError;

  /// The error message displayed when the passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authPasswordNotMatchError;

  /// Message shown when trying to reset password without entering an email address.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first.'**
  String get authPasswordResetEmailPrompt;

  /// The error message displayed when the password when the password is to short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get authPasswordShortError;

  /// The label of the password forgotten button
  ///
  /// In en, this message translates to:
  /// **'Reset here'**
  String get authPwdForgottenBtnLbl;

  /// The text of the password forgotten text
  ///
  /// In en, this message translates to:
  /// **'Forgot your password? '**
  String get authPwdForgottenText;

  /// The label of the register button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authRegisterBtnLbl;

  /// The title of the register page
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authRegisterTitle;

  /// The label for the repeated password input field
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get authRepeatPassword;

  /// The text of the sign up text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authSignUpText;

  /// The label of the sign up text button
  ///
  /// In en, this message translates to:
  /// **'Sign Up here'**
  String get authSignUpTextBtnLbl;

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

  /// Error message prefix displayed when category details fail to load.
  ///
  /// In en, this message translates to:
  /// **'Error loading category details:'**
  String get categoryDetailsErrorLoading;

  /// The title of the category details page
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryDetailsTitle;

  /// The label of the button to choose a category
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get catgoryBtnLbl;

  /// The label of the button to choose a category
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategoryBtnLbl;

  /// Error message displayed when the category is not found
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get errorCategoryNotFound;

  /// Generic error message shown in a SnackBar for unexpected issues.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorGeneric;

  /// Generic error message shown in a SnackBar when navigating between screens fails.
  ///
  /// In en, this message translates to:
  /// **'Navigation failed. Please try again.'**
  String get errorNavigationFailed;

  /// Error message displayed when no category is selected
  ///
  /// In en, this message translates to:
  /// **'Category not selected'**
  String get errorNoCategorySelected;

  /// Error message shown in a SnackBar when saving the user's quiz answer attempt fails.
  ///
  /// In en, this message translates to:
  /// **'Error saving your answer.'**
  String get errorSavingData;

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

  /// The label for the missed correct answers in the quiz results bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Missed Correct Answers:'**
  String get feedbackBSheetMissedCorrectAnswers;

  /// The label for the incorrect answers in the quiz results bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Incorrect Answers:'**
  String get feedbackBSheetWrongAnswers;

  /// The label of the button to finish the quiz
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get finishQuizBtnLbl;

  /// The name of the English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEnglish;

  /// The name of the German language
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageNameGerman;

  /// The label of the button to go to the next question
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestionBtnLbl;

  /// App bar title for the 404 error page
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get notFoundAppBarTitle;

  /// Label preceding the technical error details on the 404 page
  ///
  /// In en, this message translates to:
  /// **'Error details:'**
  String get notFoundErrorDetailsLabel;

  /// Main heading displayed on the 404 error page
  ///
  /// In en, this message translates to:
  /// **'404 - Page Not Found'**
  String get notFoundHeading;

  /// Label for the 'Done' button in pickers
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get pickerDoneButton;

  /// The name for the 'Automatic' option in a picker
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get pickerOptionAutomatic;

  /// The description for the 'Automatic' option in a picker
  ///
  /// In en, this message translates to:
  /// **'Let the app choose a category for you.'**
  String get pickerOptionAutomaticDescription;

  /// Title of the app bar for the profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileAppBarTitle;

  /// Tooltip text for changing the profile picture
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get profileChangePictureTooltip;

  /// Validation error message when the display name field is empty during profile save
  ///
  /// In en, this message translates to:
  /// **'Display name cannot be empty.'**
  String get profileDisplayNameEmptyError;

  /// Label for the display name input field
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// Title of the app bar for editing the profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditAppBarTitle;

  /// Label for the save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditBtnLbl;

  /// Tooltip for the edit button on the profile page AppBar
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTooltip;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get profileEmailLabel;

  /// Error message shown on profile page if user data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading profile data.'**
  String get profileErrorLoading;

  /// Error message shown on profile page if image selection fails
  ///
  /// In en, this message translates to:
  /// **'Error selecting an image.'**
  String get profileImagePickerError;

  /// Menu item text for logging the user out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileMenuLogout;

  /// Menu item text for navigating to the user profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileMenuProfile;

  /// Menu item text for navigating to the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileMenuSettings;

  /// Fallback text if the user has no email address
  ///
  /// In en, this message translates to:
  /// **'No email available'**
  String get profileNoEmail;

  /// Fallback text if the user has no display name
  ///
  /// In en, this message translates to:
  /// **'Add username'**
  String get profileNoUsername;

  /// Option in the bottom sheet to take a new photo with the camera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get profilePickFromCamera;

  /// Option in the bottom sheet to select an image from the device gallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get profilePickFromGallery;

  /// Tooltip for the save button on the profile page AppBar
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveTooltip;

  /// Error message shown when profile update fails
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get profileUpdateError;

  /// Success message shown when profile update succeeds
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// Message shown on profile page if the user data is null
  ///
  /// In en, this message translates to:
  /// **'User data not found.'**
  String get profileUserNotFound;

  /// The title of the quiz page in the app bar
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizAppBarTitle;

  /// The message displayed when the quiz is completed
  ///
  /// In en, this message translates to:
  /// **'🎉 Quiz Completed'**
  String get quizCompletedMsg;

  /// Error message shown in a SnackBar when loading the next quiz question fails.
  ///
  /// In en, this message translates to:
  /// **'Error loading next question.'**
  String get quizErrorLoadingNextQuestion;

  /// Error message prefix displayed when questions fail to load in the quiz page.
  ///
  /// In en, this message translates to:
  /// **'Error loading questions:'**
  String get quizErrorLoadingQuestions;

  /// Message displayed in the quiz page body or SnackBar when no questions are found for the selected topic.
  ///
  /// In en, this message translates to:
  /// **'No questions found for this topic.'**
  String get quizErrorNoQuestions;

  /// Message displayed in the quiz page when no questions are found for the selected topic.
  ///
  /// In en, this message translates to:
  /// **'No questions available for this topic yet.'**
  String get quizNoQuestionsAvailable;

  /// The label of the button to view the quiz results
  ///
  /// In en, this message translates to:
  /// **'Back to topic selection'**
  String get quizResultBtnLbl;

  /// The label for the failed quiz result
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get quizResultFailed;

  /// The label for the passed quiz result
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get quizResultPassed;

  /// The label for the quiz result score
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get quizResultScore;

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

  /// The label for the toggle explanation button
  ///
  /// In en, this message translates to:
  /// **'Here you can view the correct and incorrect answers along with explanations. Tap on the thumbs to do so!'**
  String get quizToggleExplanation;

  /// Title of the app bar for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsAppBarTitle;

  /// Label for the language selection setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// Message displayed when the locale is refreshed
  ///
  /// In en, this message translates to:
  /// **'Locale refreshed'**
  String get settingsLocaleRefreshed;

  /// Label for the refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get settingsRefreshButtonLabel;

  /// Message displayed when the theme is refreshed
  ///
  /// In en, this message translates to:
  /// **'Theme refreshed'**
  String get settingsThemeRefreshed;

  /// Label for the theme (dark/light mode) toggle switch
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeToggleLabel;

  /// The label of the button to start the quiz
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuizBtnLbl;

  /// The label of the button to submit an answer
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get submitAnswerBtnLbl;

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

  /// Title for dialogs explaining that a permission is needed.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequiredTitle;

  /// Message shown when photo library access is permanently denied, prompting the user to go to settings.
  ///
  /// In en, this message translates to:
  /// **'To select photos, please enable Photos access for Brain Bench in your device settings.'**
  String get permissionPhotosPermanentlyDenied;

  /// Message shown when camera access is permanently denied, prompting the user to go to settings.
  ///
  /// In en, this message translates to:
  /// **'To take photos, please enable Camera access for Brain Bench in your device settings.'**
  String get permissionCameraPermanentlyDenied;

  /// Brief message shown (e.g., in a SnackBar) when photo library access is denied but can be requested again.
  ///
  /// In en, this message translates to:
  /// **'Photo access denied.'**
  String get permissionPhotosDenied;

  /// Brief message shown (e.g., in a SnackBar) when camera access is denied but can be requested again.
  ///
  /// In en, this message translates to:
  /// **'Camera access denied.'**
  String get permissionCameraDenied;

  /// Label for a button that opens the application's settings page in the device settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Label for a generic cancel button, typically used in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Error message shown on profile page if user data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading profile data.'**
  String get profileLoadError;

  /// Title for the section on the home screen displaying the currently active category.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get homeActualCategorySectionTitle;

  /// Generic text indicating that content is currently loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get statusLoadingLabel;

  /// Prompt message in the actual category view when no category is selected or details are not yet loaded.
  ///
  /// In en, this message translates to:
  /// **'Select a category to see details.'**
  String get homeActualCategoryDescriptionPrompt;

  /// Message displayed in the actual category view when there are no categories to show.
  ///
  /// In en, this message translates to:
  /// **'No categories available.'**
  String get homeActualCategoryNoCategories;

  /// Error message prefix displayed in the actual category view when categories fail to load.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories:'**
  String get homeActualCategoryErrorLoading;

  /// A generic error message displayed to the user when an unexpected error occurs.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get genericErrorMessage;
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
