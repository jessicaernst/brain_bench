// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$answersHash() => r'8f15063f0daca34f778a5921c2af06337a8a4740';

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

/// See also [answers].
@ProviderFor(answers)
const answersProvider = AnswersFamily();

/// See also [answers].
class AnswersFamily extends Family<AsyncValue<List<Answer>>> {
  /// See also [answers].
  const AnswersFamily();

  /// See also [answers].
  AnswersProvider call(List<String> answerIds) {
    return AnswersProvider(answerIds);
  }

  @override
  AnswersProvider getProviderOverride(covariant AnswersProvider provider) {
    return call(provider.answerIds);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'answersProvider';
}

/// See also [answers].
class AnswersProvider extends AutoDisposeFutureProvider<List<Answer>> {
  /// See also [answers].
  AnswersProvider(List<String> answerIds)
    : this._internal(
        (ref) => answers(ref as AnswersRef, answerIds),
        from: answersProvider,
        name: r'answersProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$answersHash,
        dependencies: AnswersFamily._dependencies,
        allTransitiveDependencies: AnswersFamily._allTransitiveDependencies,
        answerIds: answerIds,
      );

  AnswersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.answerIds,
  }) : super.internal();

  final List<String> answerIds;

  @override
  Override overrideWith(
    FutureOr<List<Answer>> Function(AnswersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnswersProvider._internal(
        (ref) => create(ref as AnswersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        answerIds: answerIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Answer>> createElement() {
    return _AnswersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnswersProvider && other.answerIds == answerIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, answerIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnswersRef on AutoDisposeFutureProviderRef<List<Answer>> {
  /// The parameter `answerIds` of this provider.
  List<String> get answerIds;
}

class _AnswersProviderElement
    extends AutoDisposeFutureProviderElement<List<Answer>>
    with AnswersRef {
  _AnswersProviderElement(super.provider);

  @override
  List<String> get answerIds => (origin as AnswersProvider).answerIds;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
