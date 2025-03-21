// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryByIdHash() => r'110f46f2e2c4fa0fb40365d73bcf30d12b16d02d';

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

/// See also [categoryById].
@ProviderFor(categoryById)
const categoryByIdProvider = CategoryByIdFamily();

/// See also [categoryById].
class CategoryByIdFamily extends Family<AsyncValue<Category>> {
  /// See also [categoryById].
  const CategoryByIdFamily();

  /// See also [categoryById].
  CategoryByIdProvider call(
    String categoryId,
    String languageCode,
  ) {
    return CategoryByIdProvider(
      categoryId,
      languageCode,
    );
  }

  @override
  CategoryByIdProvider getProviderOverride(
    covariant CategoryByIdProvider provider,
  ) {
    return call(
      provider.categoryId,
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
  String? get name => r'categoryByIdProvider';
}

/// See also [categoryById].
class CategoryByIdProvider extends AutoDisposeFutureProvider<Category> {
  /// See also [categoryById].
  CategoryByIdProvider(
    String categoryId,
    String languageCode,
  ) : this._internal(
          (ref) => categoryById(
            ref as CategoryByIdRef,
            categoryId,
            languageCode,
          ),
          from: categoryByIdProvider,
          name: r'categoryByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryByIdHash,
          dependencies: CategoryByIdFamily._dependencies,
          allTransitiveDependencies:
              CategoryByIdFamily._allTransitiveDependencies,
          categoryId: categoryId,
          languageCode: languageCode,
        );

  CategoryByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.languageCode,
  }) : super.internal();

  final String categoryId;
  final String languageCode;

  @override
  Override overrideWith(
    FutureOr<Category> Function(CategoryByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryByIdProvider._internal(
        (ref) => create(ref as CategoryByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        languageCode: languageCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Category> createElement() {
    return _CategoryByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryByIdProvider &&
        other.categoryId == categoryId &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, languageCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryByIdRef on AutoDisposeFutureProviderRef<Category> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;

  /// The parameter `languageCode` of this provider.
  String get languageCode;
}

class _CategoryByIdProviderElement
    extends AutoDisposeFutureProviderElement<Category> with CategoryByIdRef {
  _CategoryByIdProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryByIdProvider).categoryId;
  @override
  String get languageCode => (origin as CategoryByIdProvider).languageCode;
}

String _$selectedCategoryNotifierHash() =>
    r'0a89fea4edf9a9e1a1189e633fc3bb69b352ece1';

/// See also [SelectedCategoryNotifier].
@ProviderFor(SelectedCategoryNotifier)
final selectedCategoryNotifierProvider =
    AutoDisposeNotifierProvider<SelectedCategoryNotifier, String?>.internal(
  SelectedCategoryNotifier.new,
  name: r'selectedCategoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategoryNotifier = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
