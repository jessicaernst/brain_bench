import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/back_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/error_views/no_data_available_view.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/presentation/quiz/controller/quiz_page_controller.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_body_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_error_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizPage');

/// The page that displays the quiz.
class QuizPage extends HookConsumerWidget {
  const QuizPage({super.key, required this.topicId, required this.categoryId});

  final String topicId;
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    final controller = ref.watch(
      quizPageControllerProvider(
        topicId: topicId,
        categoryId: categoryId,
      ).notifier,
    );

    final quizViewModel = ref.read(quizStateNotifierProvider.notifier);
    final questionsAsync = ref.watch(questionsProvider(topicId, languageCode));

    useEffect(() {
      _logger.fine(
        'Setting up questions listener for topicId=$topicId, lang=$languageCode',
      );

      final subscription = ref.listenManual<AsyncValue<List<Question>>>(
        questionsProvider(topicId, languageCode),
        (previous, next) {
          if (next is AsyncData<List<Question>>) {
            final questions = next.value;
            if (questions.isNotEmpty &&
                ref.read(quizStateNotifierProvider).questions.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ref.read(quizStateNotifierProvider).questions.isEmpty) {
                  quizViewModel.initializeQuizIfNeeded(questions, languageCode);
                }
              });
            }
          } else if (next is AsyncError) {
            controller.showErrorSnackBar(
              scaffoldMessenger,
              theme,
              () => context.mounted,
              localizations.quizErrorLoadingQuestions,
            );
          }
        },
      );

      return subscription.close;
    }, const []);

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizAppBarTitle,
        onBack:
            () => controller.handleBackButton(context, () => context.mounted),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            _logger.warning(
              'No questions available for topic $topicId. Showing fallback view.',
            );
            return NoDataAvailableView(
              text: localizations.quizErrorNoQuestions,
            );
          }

          return QuizBodyView(
            questions: questions,
            localizations: localizations,
            languageCode: languageCode,
            controller: controller,
            isMountedCheck: () => context.mounted,
            buildContext: context,
          );
        },
        loading: () => const QuizLoadingView(),
        error:
            (error, stack) => QuizErrorView(
              error: error,
              stack: stack,
              localizations: localizations,
            ),
      ),
    );
  }
}
