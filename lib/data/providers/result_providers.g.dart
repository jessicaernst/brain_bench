// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultsHash() => r'e58dc10bbb3bb1b5860a689c7b1ff203ec1bd48c';

/// See also [results].
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
    r'24b79caf462330146e7862165d66e432d5502291';

/// See also [SaveResultNotifier].
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
