// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryViewModelHash() => r'9048edd6a7d95e10aad929695c7c95df00176093';

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

abstract class _$CategoryViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<Category>> {
  late final String languageCode;

  FutureOr<List<Category>> build(
    String languageCode,
  );
}

/// See also [CategoryViewModel].
@ProviderFor(CategoryViewModel)
const categoryViewModelProvider = CategoryViewModelFamily();

/// See also [CategoryViewModel].
class CategoryViewModelFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [CategoryViewModel].
  const CategoryViewModelFamily();

  /// See also [CategoryViewModel].
  CategoryViewModelProvider call(
    String languageCode,
  ) {
    return CategoryViewModelProvider(
      languageCode,
    );
  }

  @override
  CategoryViewModelProvider getProviderOverride(
    covariant CategoryViewModelProvider provider,
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
  String? get name => r'categoryViewModelProvider';
}

/// See also [CategoryViewModel].
class CategoryViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CategoryViewModel, List<Category>> {
  /// See also [CategoryViewModel].
  CategoryViewModelProvider(
    String languageCode,
  ) : this._internal(
          () => CategoryViewModel()..languageCode = languageCode,
          from: categoryViewModelProvider,
          name: r'categoryViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryViewModelHash,
          dependencies: CategoryViewModelFamily._dependencies,
          allTransitiveDependencies:
              CategoryViewModelFamily._allTransitiveDependencies,
          languageCode: languageCode,
        );

  CategoryViewModelProvider._internal(
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
    covariant CategoryViewModel notifier,
  ) {
    return notifier.build(
      languageCode,
    );
  }

  @override
  Override overrideWith(CategoryViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CategoryViewModel, List<Category>>
      createElement() {
    return _CategoryViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryViewModelProvider &&
        other.languageCode == languageCode;
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
mixin CategoryViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<Category>> {
  /// The parameter `languageCode` of this provider.
  String get languageCode;
}

class _CategoryViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CategoryViewModel,
        List<Category>> with CategoryViewModelRef {
  _CategoryViewModelProviderElement(super.provider);

  @override
  String get languageCode => (origin as CategoryViewModelProvider).languageCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
