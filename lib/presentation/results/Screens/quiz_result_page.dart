import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
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
  QuizResultPage({
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: LightDarkSwitchBtn(
                    title: localizations.quizResultBtnLbl,
                    isActive: true,
                    onPressed: () async {
                      _logger.info('End Quiz button pressed');

                      final user =
                          await ref.watch(currentUserModelProvider.future);
                      if (user == null) {
                        _logger.warning('❌ Kein eingeloggter User gefunden.');
                        return;
                      }

                      await notifier.saveQuizResult(
                        widget.categoryId,
                        widget.topicId,
                        user.uid,
                      );

                      if (isPassed) {
                        await notifier.markTopicAsDone(
                            widget.topicId, widget.categoryId);
                        _logger.info(
                            '✅ Fortschritt & Topic als "done" gespeichert.');
                      }

                      ref.read(quizAnswersNotifierProvider.notifier).reset();
                      ref.read(quizViewModelProvider.notifier).resetQuiz();
                      notifier.toggleView(SelectedView.none);

                      if (context.mounted) {
                        context.go('/categories/details/topics',
                            extra: widget.categoryId);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
