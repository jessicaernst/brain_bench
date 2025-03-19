import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/core/styles/text_styles.dart';
import 'package:brain_bench/presentation/results/widgets/quiz_result_expanded_view.dart';
import 'package:brain_bench/presentation/results/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizResultPage');

/// This widget displays the results of a quiz, showing a list of answer cards
/// and allowing the user to filter between correct and incorrect answers.
class QuizResultPage extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends ConsumerState<QuizResultPage> {
  // ✅ ScrollController for the ListView
  final ScrollController _scrollController = ScrollController();

  // ✅ Animation constants
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const double _defaultPadding = 24.0;
  static const double _buttonSpacing = 48.0;
  static const double _explanationTextHeightFactor = 0.15;

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
      duration: _animationDuration,
      padding: padding,
      alignment: alignment,
      height: height,
      child: isVisible != null
          ? Visibility(visible: isVisible, child: child)
          : child,
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('build() called for QuizResultPage');
    // Access the current state from QuizResultNotifier.
    final state = ref.watch(quizResultNotifierProvider);

    // Access the notifier to trigger state changes.
    final notifier = ref.read(quizResultNotifierProvider.notifier);

    // Access app-wide localizations for text.
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Get the filtered list of answers from the notifier based on the current state.
    final List<QuizAnswer> filteredAnswers = notifier.getFilteredAnswers();

    // Check if there are correct or incorrect answers.
    final bool hasCorrectAnswers = notifier.hasCorrectAnswers();
    final bool hasIncorrectAnswers = notifier.hasIncorrectAnswers();

    // ✅ Calculate the score and pass/fail status
    final totalPossiblePoints = notifier.calculateTotalPossiblePoints();
    final userPoints = notifier.calculateUserPoints();
    final percentage = notifier.calculatePercentage();
    final isPassed = notifier.isQuizPassed();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.quizResultsAppBarTitle),
      ),
      body: state.quizAnswers.isEmpty
          ? Center(child: Text(localizations.quizResultsNotSaved))
          : Column(
              children: [
                // ✅ Display Score and Pass/Fail Status
                _createAnimatedContainer(
                  // ✅ Show only when not in correct/incorrect view
                  isVisible: state.selectedView == SelectedView.none,
                  child: Padding(
                    padding: const EdgeInsets.all(_defaultPadding),
                    child: Column(
                      children: [
                        Text(
                          '${localizations.quizResultScore}: $userPoints / $totalPossiblePoints \n(${percentage.toStringAsFixed(1)}%)',
                          style: BrainBenchTextStyles.title1(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isPassed
                              ? localizations.quizResultPassed
                              : localizations.quizResultFailed,
                          style: BrainBenchTextStyles.title2Bold().copyWith(
                            color: isPassed
                                ? BrainBenchColors.correctAnswerGlass
                                : BrainBenchColors.falseQuestionGlass,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ✅ Explanation Text Container
                _createAnimatedContainer(
                  height: state.selectedView == SelectedView.none
                      ? MediaQuery.of(context).size.height *
                          _explanationTextHeightFactor
                      : 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: _defaultPadding),
                    child: Visibility(
                      visible: state.selectedView == SelectedView.none,
                      child: Text(
                        localizations.quizToggleExplanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Using AnimatedContainer to manage vertical and horizontal positioning of the buttons.
                _createAnimatedContainer(
                  padding: EdgeInsets.only(
                    top: state.selectedView == SelectedView.none
                        ? _defaultPadding
                        : _defaultPadding,
                    left: _defaultPadding,
                    right: _defaultPadding,
                  ),
                  alignment: state.selectedView == SelectedView.none
                      ? Alignment.center
                      : Alignment.topLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleButton(
                          isSelected:
                              state.selectedView == SelectedView.correct,
                          icon: Icons.thumb_up,
                          isCorrect: true,
                          isActive: hasCorrectAnswers,
                          onTap: () =>
                              notifier.toggleView(SelectedView.correct, ref),
                        ),
                        const SizedBox(width: _buttonSpacing),
                        ToggleButton(
                          isSelected:
                              state.selectedView == SelectedView.incorrect,
                          icon: Icons.thumb_down,
                          isCorrect: false,
                          isActive: hasIncorrectAnswers,
                          onTap: () =>
                              notifier.toggleView(SelectedView.incorrect, ref),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: _defaultPadding),
                QuizResultExpandedView(
                  scrollController: _scrollController,
                  filteredAnswers: filteredAnswers,
                  defaultPadding: _defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      _defaultPadding, 16, _defaultPadding, 32),
                  child: LightDarkSwitchBtn(
                      title: localizations.quizResultBtnLbl,
                      isActive: true,
                      onPressed: () {
                        _logger.info('End Quiz button pressed');
                        // TODO: add save quiz and navigation

                        // Reset the state of QuizAnswersNotifier when navigating back.
                        ref.read(quizAnswersNotifierProvider.notifier).reset();

                        // Reset the state of QuizViewModel when navigating back.
                        ref.read(quizViewModelProvider.notifier).resetQuiz(ref);

                        // Reset the selected view to none.
                        notifier.toggleView(SelectedView.none, ref);

                        // Navigate back to the topics page for the current category.
                        context.go('/categories/details/topics',
                            extra: {'categoryId': widget.categoryId});
                      }),
                )
              ],
            ),
    );
  }
}
