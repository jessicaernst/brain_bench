import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/presentation/results/widgets/answer_card.dart';
import 'package:brain_bench/presentation/results/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

/// This widget displays the results of a quiz, showing a list of answer cards
/// and allowing the user to filter between correct and incorrect answers.
class QuizResultPage extends ConsumerWidget {
  /// Creates a [QuizResultPage].
  ///
  /// The [categoryId] parameter is required and represents the ID of the
  /// category for which the quiz was taken.
  const QuizResultPage({
    super.key,
    required this.categoryId,
  });

  /// The ID of the category the quiz belongs to.
  final String categoryId;

  // ✅ Animation constants - Defining these as constants improves readability and maintainability.
  /// The duration for all animations in this page.
  static const Duration _animationDuration = Duration(milliseconds: 300);

  /// The default padding used throughout the page.
  static const double _defaultPadding = 24.0;

  /// The horizontal spacing between the toggle buttons.
  static const double _buttonSpacing = 48.0;

  /// The factor used to calculate the height of the explanatory text.
  static const double _explanationTextHeightFactor = 0.25;

  // ✅ Method for creating the animated containers - This method centralizes the creation of AnimatedContainers.
  /// Creates an [AnimatedContainer] with consistent settings for animations, padding, alignment, and visibility.
  ///
  /// [child]: The widget to be animated.
  /// [padding]: The padding around the child.
  /// [alignment]: The alignment of the child within the container.
  /// [height]: The height of the container.
  /// [isVisible]: Whether the child should be visible.
  AnimatedContainer _createAnimatedContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? height,
    bool? isVisible,
  }) {
    return AnimatedContainer(
      duration: _animationDuration, // Use the predefined animation duration.
      padding: padding, // Apply the provided padding.
      alignment: alignment, // Apply the provided alignment.
      height: height, // Apply the provided height.
      child: isVisible != null
          ? Visibility(
              visible: isVisible,
              child: child) // Conditionally show the child based on isVisible.
          : child, // If isVisible is not provided, always show the child.
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current state from QuizResultNotifier.
    final state = ref.watch(quizResultNotifierProvider);

    // Access the notifier to trigger state changes.
    final notifier = ref.read(quizResultNotifierProvider.notifier);

    // Access app-wide localizations for text.
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Get the filtered list of answers from the notifier based on the current state.
    final List<QuizAnswer> filteredAnswers = notifier.getFilteredAnswers();

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizResultsAppBarTitle,
        onBack: () {
          // Reset the state of QuizAnswersNotifier when navigating back.
          ref.read(quizAnswersNotifierProvider.notifier).reset();

          // Reset the state of QuizViewModel when navigating back.
          ref.read(quizViewModelProvider.notifier).resetQuiz(ref);

          // Reset the selected view to none.
          notifier.toggleView(SelectedView.none, ref);

          // Navigate back to the topics page for the current category.
          context.go('/categories/details/topics', extra: categoryId);
        },
      ),
      body: state.quizAnswers.isEmpty
          ? Center(
              child: Text(localizations
                  .quizResultsNotSaved)) // Display a message if no quiz answers are available.
          : Column(
              children: [
                // ✅ Show explanatory text conditionally - Display the explanatory text if no filter is selected and no cards are expanded.
                _createAnimatedContainer(
                  height: state.shouldShowExplanationText
                      ? MediaQuery.of(context).size.height *
                          _explanationTextHeightFactor // Calculate the height based on screen size.
                      : 0, // Hide the text by setting the height to 0.
                  isVisible: state
                      .shouldShowExplanationText, // Control the visibility.
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal:
                              _defaultPadding), // Add horizontal padding to the text.
                      child: ClipRect(
                        child: Text(
                          localizations
                              .quizToggleExplanation, // Get the localized text.
                          textAlign:
                              TextAlign.center, // Center the text horizontally.
                        ),
                      ),
                    ),
                  ),
                ),
                // ✅ Using AnimatedContainer to manage vertical and horizontal positioning of the buttons. - Animate the button row's position and padding.
                _createAnimatedContainer(
                  padding: EdgeInsets.only(
                    top: state.selectedView == SelectedView.none
                        ? 0
                        : _defaultPadding, // Set top padding to 0 if no filter is selected, otherwise use the default padding.
                    left: _defaultPadding,
                    right: _defaultPadding,
                  ),
                  alignment: state.selectedView == SelectedView.none
                      ? Alignment.center
                      : Alignment
                          .topLeft, // Center the buttons if no filter is selected, otherwise align to the top-left.
                  child: SizedBox(
                    width: double
                        .infinity, // Make the SizedBox take up all available horizontal space.
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the buttons horizontally.
                      children: [
                        // ToggleButton for correct answers.
                        ToggleButton(
                          isSelected:
                              state.selectedView == SelectedView.correct,
                          icon: Icons.thumb_up,
                          isCorrect: true,
                          onTap: () => notifier.toggleView(SelectedView.correct,
                              ref), // Switch to correct view.
                        ),
                        const SizedBox(
                            width:
                                _buttonSpacing), // Add spacing between the buttons.
                        // ToggleButton for incorrect answers.
                        ToggleButton(
                          isSelected:
                              state.selectedView == SelectedView.incorrect,
                          icon: Icons.thumb_down,
                          isCorrect: false,
                          onTap: () => notifier.toggleView(
                              SelectedView.incorrect,
                              ref), // Switch to incorrect view.
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        _defaultPadding), // Add default spacing below the button row.
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredAnswers
                        .length, // Use the length of the filtered list.
                    separatorBuilder: (context, index) => const SizedBox(
                        height:
                            _defaultPadding), // Add spacing between answer cards.
                    itemBuilder: (context, index) {
                      // Get the answer card data for this index.
                      final answer = filteredAnswers[index];

                      // Create and return an AnswerCard widget.
                      return AnswerCard(
                        answer: answer,
                        isCorrect: answer.incorrectAnswers.isEmpty,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      _defaultPadding), // Add padding around the button.
                  child: LightDarkSwitchBtn(
                      title: 'End Quiz',
                      isActive: true,
                      onPressed: () {}), // Button to end the quiz.
                )
              ],
            ),
    );
  }
}
