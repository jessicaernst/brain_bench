// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizResultNotifierHash() =>
    r'00938ba3b9bf5843aadd47134fc22f13588eaec8';

/// A Riverpod notifier that manages the state of the quiz result page.
///
/// This notifier is responsible for:
/// - Managing the selected view (none, correct, incorrect).
/// - Managing the expanded answers.
/// - Providing a filtered list of answers based on the selected view.
/// - Calculating the total possible points, user points, and percentage.
/// - Determining if the quiz was passed.
/// - Saving the quiz result to the database.
/// - Marking a topic as done in the database.
///
/// Copied from [QuizResultNotifier].
@ProviderFor(QuizResultNotifier)
final quizResultNotifierProvider =
    AutoDisposeNotifierProvider<QuizResultNotifier, QuizResultState>.internal(
      QuizResultNotifier.new,
      name: r'quizResultNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$quizResultNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuizResultNotifier = AutoDisposeNotifier<QuizResultState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
