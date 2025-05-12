// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicsHash() => r'71750e62a94b615c9f18bf65472c1df461fff88d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [topics].
@ProviderFor(topics)
const topicsProvider = TopicsFamily();

/// See also [topics].
class TopicsFamily extends Family<AsyncValue<List<Topic>>> {
  /// See also [topics].
  const TopicsFamily();

  /// See also [topics].
  TopicsProvider call(String categoryId) {
    return TopicsProvider(categoryId);
  }

  @override
  TopicsProvider getProviderOverride(covariant TopicsProvider provider) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topicsProvider';
}

/// See also [topics].
class TopicsProvider extends AutoDisposeFutureProvider<List<Topic>> {
  /// See also [topics].
  TopicsProvider(String categoryId)
    : this._internal(
        (ref) => topics(ref as TopicsRef, categoryId),
        from: topicsProvider,
        name: r'topicsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$topicsHash,
        dependencies: TopicsFamily._dependencies,
        allTransitiveDependencies: TopicsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  TopicsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Topic>> Function(TopicsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicsProvider._internal(
        (ref) => create(ref as TopicsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Topic>> createElement() {
    return _TopicsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicsProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicsRef on AutoDisposeFutureProviderRef<List<Topic>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _TopicsProviderElement
    extends AutoDisposeFutureProviderElement<List<Topic>>
    with TopicsRef {
  _TopicsProviderElement(super.provider);

  @override
  String get categoryId => (origin as TopicsProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
