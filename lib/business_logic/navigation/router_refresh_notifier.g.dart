// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_refresh_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerRefreshNotifierHash() =>
    r'5bb9ae0e3a979ddefccef0aab2a8ff5b815450bd';

/// Provides the singleton instance of [RouterRefreshNotifier].
///
/// Annotated with `@Riverpod(keepAlive: true)`:
/// - `@Riverpod`: Generates the necessary provider code (`routerRefreshNotifierProvider`).
/// - `keepAlive: true`: Ensures that the [RouterRefreshNotifier] instance is
///   not automatically disposed when there are no active listeners from the UI.
///   This is crucial because GoRouter needs this listener to persist throughout
///   the app's lifecycle to react to auth changes at any time.
///
/// Copied from [routerRefreshNotifier].
@ProviderFor(routerRefreshNotifier)
final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>.internal(
  routerRefreshNotifier,
  name: r'routerRefreshNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerRefreshNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRefreshNotifierRef = ProviderRef<RouterRefreshNotifier>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
