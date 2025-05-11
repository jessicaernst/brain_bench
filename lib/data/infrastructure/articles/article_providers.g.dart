// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$articleRepositoryHash() => r'75f0d829b945acfc61b99bbd163464640c62cf23';

/// Returns an instance of [ArticleRepository] using [ArticleMockRepositoryImpl] as the implementation.
/// The [ArticleMockRepositoryImpl] is initialized with the path to the articles JSON file
/// in the documents directory, after potentially copying it from assets.
///
/// Copied from [articleRepository].
@ProviderFor(articleRepository)
final articleRepositoryProvider = FutureProvider<ArticleRepository>.internal(
  articleRepository,
  name: r'articleRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$articleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArticleRepositoryRef = FutureProviderRef<ArticleRepository>;
String _$articlesHash() => r'1dbcaa81633bc48ee8c33e61157a6ed2072e5d1c';

/// Retrieves a list of articles from the [ArticleRepository].
/// Returns a [Future] that resolves to a list of [Article] objects.
///
/// Copied from [articles].
@ProviderFor(articles)
final articlesProvider = AutoDisposeFutureProvider<List<Article>>.internal(
  articles,
  name: r'articlesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$articlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArticlesRef = AutoDisposeFutureProviderRef<List<Article>>;
String _$articleByIdHash() => r'9c8f7ca62b1161317047ddba0946103cf91fe49e';

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

/// Retrieves an article by its [id] from the [ArticleRepository].
/// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
///
/// Copied from [articleById].
@ProviderFor(articleById)
const articleByIdProvider = ArticleByIdFamily();

/// Retrieves an article by its [id] from the [ArticleRepository].
/// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
///
/// Copied from [articleById].
class ArticleByIdFamily extends Family<AsyncValue<Article?>> {
  /// Retrieves an article by its [id] from the [ArticleRepository].
  /// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
  ///
  /// Copied from [articleById].
  const ArticleByIdFamily();

  /// Retrieves an article by its [id] from the [ArticleRepository].
  /// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
  ///
  /// Copied from [articleById].
  ArticleByIdProvider call(String id) {
    return ArticleByIdProvider(id);
  }

  @override
  ArticleByIdProvider getProviderOverride(
    covariant ArticleByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'articleByIdProvider';
}

/// Retrieves an article by its [id] from the [ArticleRepository].
/// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
///
/// Copied from [articleById].
class ArticleByIdProvider extends AutoDisposeFutureProvider<Article?> {
  /// Retrieves an article by its [id] from the [ArticleRepository].
  /// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
  ///
  /// Copied from [articleById].
  ArticleByIdProvider(String id)
    : this._internal(
        (ref) => articleById(ref as ArticleByIdRef, id),
        from: articleByIdProvider,
        name: r'articleByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$articleByIdHash,
        dependencies: ArticleByIdFamily._dependencies,
        allTransitiveDependencies: ArticleByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ArticleByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Article?> Function(ArticleByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticleByIdProvider._internal(
        (ref) => create(ref as ArticleByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Article?> createElement() {
    return _ArticleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticleByIdRef on AutoDisposeFutureProviderRef<Article?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ArticleByIdProviderElement
    extends AutoDisposeFutureProviderElement<Article?>
    with ArticleByIdRef {
  _ArticleByIdProviderElement(super.provider);

  @override
  String get id => (origin as ArticleByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
