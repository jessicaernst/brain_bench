import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
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

/// A page that displays the result of a quiz.
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

  Future<void> _handleEndQuiz() async {
    _logger.info('End Quiz button pressed');
    // Store notifier and localizations at the beginning
    // as they don't depend on async operations and are safe if widget is initially mounted.
    final notifier = ref.read(quizResultNotifierProvider.notifier);
    // context access for localizations should be guarded if used after an await
    // but here it's at the start, so it's fine if the widget is mounted.
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;

    // Fetch the current user state
    final userState = await ref.read(
      currentUserModelProvider.future,
    ); // Use read for one-time fetch in async callback
    if (!mounted) return; // Check mounted after first await

    // Use pattern matching to handle the user state
    final AppUser? userData = switch (userState) {
      UserModelData(:final user) => user,
      _ => null,
    };

    if (userData == null) {
      // Log the specific reason based on the state
      switch (userState) {
        case UserModelUnauthenticated():
          _logger.warning('❌ User ist nicht eingeloggt.');
        case UserModelLoading():
          _logger.warning('⏳ User wird noch geladen.');
        case UserModelError(:final message):
          _logger.warning('❌ Fehler beim Laden des Users: $message');
        case UserModelData():
          _logger.severe(
            '❌ Inkonsistenter Zustand: UserModelData aber kein User extrahiert.',
          );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.quizResultsUserNotAvailable)),
        );
      }
      return;
    }

    // At this point, userData is not null and widget was mounted after fetching user.
    _logger.info('✅ User ist eingeloggt (UID: ${userData.uid}).');

    await notifier.saveQuizResult(
      widget.categoryId,
      widget.topicId,
      userData.uid,
    ); // Await operation
    if (!mounted) return; // Check mounted after saving quiz result
    _logger.info(
      'Quiz result saved for category: ${widget.categoryId}, topic: ${widget.topicId}',
    );

    try {
      await notifier.updateLastPlayedCategory(userData, widget.categoryId);
    } catch (e, stack) {
      // No mounted check before logger, as logger itself is safe.
      _logger.severe(
        'Failed to update last played category for user ${userData.uid}: $e',
        e,
        stack,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.quizResultsSaveLastCategoryError),
            action: SnackBarAction(
              label: localizations.quizResultsRetryButton,
              onPressed: () async {
                if (!mounted) return; // Check before retry async
                try {
                  // Korrekter Aufruf auch hier
                  await notifier.updateLastPlayedCategory(
                    userData,
                    widget.categoryId,
                  );
                  _logger.info(
                    'Retry for updateLastPlayedCategory successful.',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.quizResultsSaveLastCategorySuccess,
                        ),
                      ),
                    );
                  }
                } catch (retryError) {
                  _logger.severe(
                    'Retry for updateLastPlayedCategory also failed: $retryError',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.quizResultsSaveLastCategoryRetryFailed,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      }
    }

    // Save to SharedPreferences
    try {
      if (!mounted) {
        return;
      }
      final settingsRepo = ref.read(settingsRepositoryProvider);
      await settingsRepo.saveLastSelectedCategoryId(
        widget.categoryId,
      ); // Await operation
      if (!mounted) return; // Check after saving to SharedPreferences
      ref.invalidate(lastSelectedCategoryIdFromPrefsProvider);
      _logger.info(
        'Last played category ID ${widget.categoryId} also saved to SharedPreferences.',
      );
    } catch (e) {
      // Logger is safe, no mounted check needed for it.
      _logger.warning(
        'Failed to save last played category ID to SharedPreferences: $e',
      );
    }

    // Mark topic as done
    // notifier.isQuizPassed() is safe as notifier was obtained when widget was mounted.
    if (notifier.isQuizPassed()) {
      await notifier.markTopicAsDone(
        userData, // userData was captured when widget was mounted.
        widget.topicId,
        widget.categoryId,
      ); // Await operation
      if (!mounted) return; // Check after marking topic as done
      _logger.info('✅ Fortschritt & Topic als "done" gespeichert.');
    }

    // Final resets and navigation
    if (!mounted) {
      // Logger is safe.
      _logger.warning(
        'QuizResultPage unmounted before final resets and navigation.',
      );
      return;
    }

    ref.read(quizAnswersNotifierProvider.notifier).reset();
    ref.read(quizStateNotifierProvider.notifier).resetQuiz();
    notifier.toggleView(SelectedView.none); // notifier instance is safe

    // context.mounted is implicitly true here due to the `if (!mounted) return;` above.
    // However, explicit check for context is good practice before navigation.
    if (context.mounted) {
      context.goNamed(
        AppRouteNames.topics,
        pathParameters: {'categoryId': widget.categoryId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizResultNotifierProvider);
    final notifier = ref.read(quizResultNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    final filteredAnswers = notifier.getFilteredAnswers();
    final totalPossiblePoints = notifier.calculateTotalPossiblePoints();
    final userPoints = notifier.calculateUserPoints();
    final percentage = notifier.calculatePercentage();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.quizResultsAppBarTitle),
        automaticallyImplyLeading: false,
      ),
      body:
          state.quizAnswers.isEmpty
              ? Center(child: Text(localizations.quizResultsNotSaved))
              : Column(
                children: [
                  QuizResultHeader(
                    isVisible: state.selectedView == SelectedView.none,
                    userPoints: userPoints,
                    totalPoints: totalPossiblePoints,
                    percentage: percentage,
                    isPassed: notifier.isQuizPassed(),
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
                      onPressed: _handleEndQuiz,
                    ),
                  ),
                ],
              ),
    );
  }
}
