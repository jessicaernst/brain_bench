// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultsHash() => r'fb69eaf7cbdb44997d449fcc52df47bb51f20d95';

/// Provides a list of [Result] objects for the currently logged-in user.
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
    r'ca849314bcc8bd32ded979e74fdb577bd6ea7185';

/// A notifier that handles saving quiz results and marking topics as done.
///
/// This notifier uses the [quizMockDatabaseRepositoryProvider] to interact
/// with the database.
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
