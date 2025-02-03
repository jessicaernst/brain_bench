// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buildHash() => r'da3c00e9c90c468cb8c007bd2c83229a359a825a';

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

/// See also [build].
@ProviderFor(build)
const buildProvider = BuildFamily();

/// See also [build].
class BuildFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [build].
  const BuildFamily();

  /// See also [build].
  BuildProvider call(
    String languageCode,
  ) {
    return BuildProvider(
      languageCode,
    );
  }

  @override
  BuildProvider getProviderOverride(
    covariant BuildProvider provider,
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
  String? get name => r'buildProvider';
}

/// See also [build].
class BuildProvider extends AutoDisposeFutureProvider<List<Category>> {
  /// See also [build].
  BuildProvider(
    String languageCode,
  ) : this._internal(
          (ref) => build(
            ref as BuildRef,
            languageCode,
          ),
          from: buildProvider,
          name: r'buildProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$buildHash,
          dependencies: BuildFamily._dependencies,
          allTransitiveDependencies: BuildFamily._allTransitiveDependencies,
          languageCode: languageCode,
        );

  BuildProvider._internal(
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
  Override overrideWith(
    FutureOr<List<Category>> Function(BuildRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BuildProvider._internal(
        (ref) => create(ref as BuildRef),
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
  AutoDisposeFutureProviderElement<List<Category>> createElement() {
    return _BuildProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BuildProvider && other.languageCode == languageCode;
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
mixin BuildRef on AutoDisposeFutureProviderRef<List<Category>> {
  /// The parameter `languageCode` of this provider.
  String get languageCode;
}

class _BuildProviderElement
    extends AutoDisposeFutureProviderElement<List<Category>> with BuildRef {
  _BuildProviderElement(super.provider);

  @override
  String get languageCode => (origin as BuildProvider).languageCode;
}

String _$selectedCategoryNotifierHash() =>
    r'4a4fd2be30cf33489c04a0f5fffc0ffcc4caa646';

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
