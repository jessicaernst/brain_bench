// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'e118c46d62aec9e97adf1fdf65589fcb1128ca77';

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

abstract class _$Categories
    extends BuildlessAutoDisposeAsyncNotifier<List<Category>> {
  late final String languageCode;

  FutureOr<List<Category>> build(
    String languageCode,
  );
}

/// See also [Categories].
@ProviderFor(Categories)
const categoriesProvider = CategoriesFamily();

/// See also [Categories].
class CategoriesFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [Categories].
  const CategoriesFamily();

  /// See also [Categories].
  CategoriesProvider call(
    String languageCode,
  ) {
    return CategoriesProvider(
      languageCode,
    );
  }

  @override
  CategoriesProvider getProviderOverride(
    covariant CategoriesProvider provider,
  ) {
    return call(
      provider.languageCode,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoriesProvider';
}

/// See also [Categories].
class CategoriesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Categories, List<Category>> {
  /// See also [Categories].
  CategoriesProvider(
    String languageCode,
  ) : this._internal(
          () => Categories()..languageCode = languageCode,
          from: categoriesProvider,
          name: r'categoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoriesHash,
          dependencies: CategoriesFamily._dependencies,
          allTransitiveDependencies:
              CategoriesFamily._allTransitiveDependencies,
          languageCode: languageCode,
        );

  CategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.languageCode,
  }) : super.internal();

  final String languageCode;

  @override
  FutureOr<List<Category>> runNotifierBuild(
    covariant Categories notifier,
  ) {
    return notifier.build(
      languageCode,
    );
  }

  @override
  Override overrideWith(Categories Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoriesProvider._internal(
        () => create()..languageCode = languageCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        languageCode: languageCode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Categories, List<Category>>
      createElement() {
    return _CategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesProvider && other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, languageCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesRef on AutoDisposeAsyncNotifierProviderRef<List<Category>> {
  /// The parameter `languageCode` of this provider.
  String get languageCode;
}

class _CategoriesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Categories, List<Category>>
    with CategoriesRef {
  _CategoriesProviderElement(super.provider);

  @override
  String get languageCode => (origin as CategoriesProvider).languageCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
