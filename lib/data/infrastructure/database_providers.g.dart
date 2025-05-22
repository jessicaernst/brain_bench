// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userFirebaseRepositoryHash() =>
    r'a44591ac29f4301e02971d7ffb97d0b04fcb2ac1';

/// See also [userFirebaseRepository].
@ProviderFor(userFirebaseRepository)
final userFirebaseRepositoryProvider =
    AutoDisposeProvider<UserRepository>.internal(
      userFirebaseRepository,
      name: r'userFirebaseRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userFirebaseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserFirebaseRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$quizFirebaseRepositoryHash() =>
    r'3fa37a1b8eeed289ee9245e7b9a8d6acde70b901';

/// See also [quizFirebaseRepository].
@ProviderFor(quizFirebaseRepository)
final quizFirebaseRepositoryProvider =
    AutoDisposeProvider<DatabaseRepository>.internal(
      quizFirebaseRepository,
      name: r'quizFirebaseRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$quizFirebaseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizFirebaseRepositoryRef = AutoDisposeProviderRef<DatabaseRepository>;
String _$initialDataLoadHash() => r'0677163cf5a3c623a6ea0484aaf444c284e29360';

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

/// See also [initialDataLoad].
@ProviderFor(initialDataLoad)
const initialDataLoadProvider = InitialDataLoadFamily();

/// See also [initialDataLoad].
class InitialDataLoadFamily extends Family<AsyncValue<void>> {
  /// See also [initialDataLoad].
  const InitialDataLoadFamily();

  /// See also [initialDataLoad].
  InitialDataLoadProvider call(String userId) {
    return InitialDataLoadProvider(userId);
  }

  @override
  InitialDataLoadProvider getProviderOverride(
    covariant InitialDataLoadProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'initialDataLoadProvider';
}

/// See also [initialDataLoad].
class InitialDataLoadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [initialDataLoad].
  InitialDataLoadProvider(String userId)
    : this._internal(
        (ref) => initialDataLoad(ref as InitialDataLoadRef, userId),
        from: initialDataLoadProvider,
        name: r'initialDataLoadProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$initialDataLoadHash,
        dependencies: InitialDataLoadFamily._dependencies,
        allTransitiveDependencies:
            InitialDataLoadFamily._allTransitiveDependencies,
        userId: userId,
      );

  InitialDataLoadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<void> Function(InitialDataLoadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InitialDataLoadProvider._internal(
        (ref) => create(ref as InitialDataLoadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _InitialDataLoadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InitialDataLoadProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InitialDataLoadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _InitialDataLoadProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with InitialDataLoadRef {
  _InitialDataLoadProviderElement(super.provider);

  @override
  String get userId => (origin as InitialDataLoadProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
