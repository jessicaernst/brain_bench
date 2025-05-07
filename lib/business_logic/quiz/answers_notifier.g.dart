// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$answersNotifierHash() => r'd231ee4b4bc7bf4db289de4a79b1ecca89416d2e';

/// A Riverpod notifier that manages a list of [Answer] objects.
///
/// This notifier is responsible for storing and managing the answers for a
/// single question in a quiz. It keeps track of the answers, their selected
/// state, and provides methods to initialize, toggle, and reset the answers.
///
/// Copied from [AnswersNotifier].
@ProviderFor(AnswersNotifier)
final answersNotifierProvider =
    NotifierProvider<AnswersNotifier, List<Answer>>.internal(
      AnswersNotifier.new,
      name: r'answersNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$answersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnswersNotifier = Notifier<List<Answer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
