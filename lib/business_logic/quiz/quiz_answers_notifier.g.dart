// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answers_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizAnswersNotifierHash() =>
    r'f98c5ec68fe9a6038df0ad3c883b954fd39d6999';

/// A Riverpod notifier that manages a list of [QuizAnswer] objects.
///
/// This notifier is responsible for storing and managing the answers given by
/// the user during a quiz. It keeps track of the question, the user's given
/// answers, the correct answers, and calculates the points earned for each
/// answer.
///
/// Copied from [QuizAnswersNotifier].
@ProviderFor(QuizAnswersNotifier)
final quizAnswersNotifierProvider =
    NotifierProvider<QuizAnswersNotifier, List<QuizAnswer>>.internal(
      QuizAnswersNotifier.new,
      name: r'quizAnswersNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$quizAnswersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuizAnswersNotifier = Notifier<List<QuizAnswer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
