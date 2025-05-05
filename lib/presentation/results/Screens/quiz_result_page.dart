import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/results/widgets/quiz_result_expanded_view.dart';
import 'package:brain_bench/presentation/results/widgets/quiz_result_header.dart';
import 'package:brain_bench/presentation/results/widgets/quiz_result_info_text.dart';
import 'package:brain_bench/presentation/results/widgets/quiz_result_toggle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizResultPage');

class QuizResultPage extends ConsumerStatefulWidget {
  const QuizResultPage({
    super.key,
    required this.categoryId,
    required this.topicId,
  });

  final String categoryId;
  final String topicId;

  @override
  ConsumerState<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends ConsumerState<QuizResultPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizResultNotifierProvider);
    final notifier = ref.read(quizResultNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    final filteredAnswers = notifier.getFilteredAnswers();
    final totalPossiblePoints = notifier.calculateTotalPossiblePoints();
    final userPoints = notifier.calculateUserPoints();
    final percentage = notifier.calculatePercentage();
    final isPassed = notifier.isQuizPassed();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.quizResultsAppBarTitle),
        automaticallyImplyLeading: false,
      ),
      body: state.quizAnswers.isEmpty
          ? Center(child: Text(localizations.quizResultsNotSaved))
          : Column(
              children: [
                QuizResultHeader(
                  isVisible: state.selectedView == SelectedView.none,
                  userPoints: userPoints,
                  totalPoints: totalPossiblePoints,
                  percentage: percentage,
                  isPassed: isPassed,
                  localizations: localizations,
                ),
                const QuizResultInfoText(),
                const QuizResultToggleButtons(),
                const SizedBox(height: 24),
                QuizResultExpandedView(
                  scrollController: _scrollController,
                  filteredAnswers: filteredAnswers,
                  defaultPadding: 24,
                  expandedAnswers: state.expandedAnswers,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: LightDarkSwitchBtn(
                    title: localizations.quizResultBtnLbl,
                    isActive: true,
                    onPressed: () async {
                      _logger.info('End Quiz button pressed');

                      // Fetch the current user state
                      final userState =
                          await ref.watch(currentUserModelProvider.future);

                      // Use pattern matching to handle the user state
                      final AppUser? userData = switch (userState) {
                        UserModelData(:final user) => user,
                        UserModelUnauthenticated() => null,
                        UserModelLoading() => null,
                        UserModelError() => null,
                      };

                      if (userData == null) {
                        // Log the specific reason based on the state
                        switch (userState) {
                          case UserModelUnauthenticated():
                            _logger.warning('❌ User ist nicht eingeloggt.');
                          case UserModelLoading():
                            _logger.warning('⏳ User wird noch geladen.');
                          case UserModelError(:final message):
                            _logger.warning(
                                '❌ Fehler beim Laden des Users: $message');
                          case UserModelData():
                            _logger.severe(
                                '❌ Inkonsistenter Zustand: UserModelData aber kein User extrahiert.');
                        }
                        return;
                      }

                      _logger.info(
                          '✅ User ist eingeloggt (UID: ${userData.uid}).');

                      await notifier.saveQuizResult(
                        widget.categoryId,
                        widget.topicId,
                        userData.uid,
                      );

                      if (isPassed) {
                        await notifier.markTopicAsDone(
                          widget.topicId,
                          widget.categoryId,
                        );
                        _logger.info(
                            '✅ Fortschritt & Topic als "done" gespeichert.');
                      }

                      ref.read(quizAnswersNotifierProvider.notifier).reset();
                      ref.read(quizStateNotifierProvider.notifier).resetQuiz();
                      notifier.toggleView(SelectedView.none);

                      if (context.mounted) {
                        context.goNamed(
                          AppRouteNames.topics,
                          pathParameters: {
                            'categoryId': widget.categoryId,
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
