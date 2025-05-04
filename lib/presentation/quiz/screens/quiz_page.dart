import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/presentation/quiz/controller/quiz_page_controller.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_body_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_error_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizPage');

class QuizPage extends ConsumerStatefulWidget {
  QuizPage({
    super.key,
    required this.topicId,
    required this.categoryId,
  });

  final String topicId;
  final String categoryId;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    _logger.finer(
        'Build QuizPage for Topic ID: ${widget.topicId}, Language: $languageCode');

    final controller = ref.read(quizPageControllerProvider(
            topicId: widget.topicId, categoryId: widget.categoryId)
        .notifier);

    final QuizStateNotifier quizViewModel =
        ref.read(quizStateNotifierProvider.notifier);
    final AsyncValue<List<Question>> questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    // Listener to initialize the quiz when questions are loaded
    ref.listen<AsyncValue<List<Question>>>(
      questionsProvider(widget.topicId, languageCode),
      (previous, next) {
        if (!mounted) return;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final theme = Theme.of(context);

        if (next is AsyncData<List<Question>>) {
          final questions = next.value;
          if (questions.isNotEmpty &&
              ref.read(quizStateNotifierProvider).questions.isEmpty) {
            _logger.info(
                'questionsProvider has data, triggering quiz initialization...');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  ref.read(quizStateNotifierProvider).questions.isEmpty) {
                quizViewModel.initializeQuizIfNeeded(questions, languageCode);
              }
            });
          } else if (questions.isEmpty) {
            _logger.warning(
                'questionsProvider returned empty list. QuizBodyView will handle display.');
          }
        } else if (next is AsyncError) {
          _logger.severe('Error in questionsProvider listener: ${next.error}');
          if (mounted) {
            controller.showErrorSnackBar(scaffoldMessenger, theme,
                () => mounted, localizations.quizErrorLoadingQuestions);
          }
        }
      },
    );

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizAppBarTitle,
        onBack: () => controller.handleBackButton(context, () => mounted),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            _logger.warning(
                'No questions available for topic ${widget.topicId}. Displaying NoDataAvailableView.');
            return NoDataAvailableView(
              text: localizations.quizErrorNoQuestions,
            );
          }

          return QuizBodyView(
            questions: questions,
            localizations: localizations,
            languageCode: languageCode,
            controller: controller,
            isMountedCheck: () => mounted,
            buildContext: context,
          );
        },
        loading: () => const QuizLoadingView(),
        error: (error, stack) => QuizErrorView(
          error: error,
          stack: stack,
          localizations: localizations,
        ),
      ),
    );
  }
}
