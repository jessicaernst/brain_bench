// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultsHash() => r'f9ee3d9baeb873ad68cfd0787f7ea1c8e937cc49';

/// Provides a list of [Result] objects for a specific user.
///
/// This provider uses the [quizMockDatabaseRepositoryProvider] to fetch the
/// results from the mock database.
///
/// Copied from [results].
@ProviderFor(results)
final resultsProvider = AutoDisposeFutureProvider<List<Result>>.internal(
  results,
  name: r'resultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResultsRef = AutoDisposeFutureProviderRef<List<Result>>;
String _$saveResultNotifierHash() =>
    r'fe0ca9d9f54c02abc1a93562117661bc090ca2e3';

/// A notifier that handles saving quiz results and marking topics as done.
///
/// This notifier uses the [quizMockDatabaseRepositoryProvider] to interact
/// with the mock database.
///
/// Copied from [SaveResultNotifier].
@ProviderFor(SaveResultNotifier)
final saveResultNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SaveResultNotifier, void>.internal(
  SaveResultNotifier.new,
  name: r'saveResultNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveResultNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveResultNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
