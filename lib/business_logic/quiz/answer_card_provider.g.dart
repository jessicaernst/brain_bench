// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$answerCardExpandedHash() =>
    r'f1b8d16e061891fc3e09d360b9972ba04f1b1406';

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

abstract class _$AnswerCardExpanded extends BuildlessAutoDisposeNotifier<bool> {
  late final String questionId;

  bool build(String questionId);
}

/// See also [AnswerCardExpanded].
@ProviderFor(AnswerCardExpanded)
const answerCardExpandedProvider = AnswerCardExpandedFamily();

/// See also [AnswerCardExpanded].
class AnswerCardExpandedFamily extends Family<bool> {
  /// See also [AnswerCardExpanded].
  const AnswerCardExpandedFamily();

  /// See also [AnswerCardExpanded].
  AnswerCardExpandedProvider call(String questionId) {
    return AnswerCardExpandedProvider(questionId);
  }

  @override
  AnswerCardExpandedProvider getProviderOverride(
    covariant AnswerCardExpandedProvider provider,
  ) {
    return call(provider.questionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'answerCardExpandedProvider';
}

/// See also [AnswerCardExpanded].
class AnswerCardExpandedProvider
    extends AutoDisposeNotifierProviderImpl<AnswerCardExpanded, bool> {
  /// See also [AnswerCardExpanded].
  AnswerCardExpandedProvider(String questionId)
    : this._internal(
        () => AnswerCardExpanded()..questionId = questionId,
        from: answerCardExpandedProvider,
        name: r'answerCardExpandedProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$answerCardExpandedHash,
        dependencies: AnswerCardExpandedFamily._dependencies,
        allTransitiveDependencies:
            AnswerCardExpandedFamily._allTransitiveDependencies,
        questionId: questionId,
      );

  AnswerCardExpandedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.questionId,
  }) : super.internal();

  final String questionId;

  @override
  bool runNotifierBuild(covariant AnswerCardExpanded notifier) {
    return notifier.build(questionId);
  }

  @override
  Override overrideWith(AnswerCardExpanded Function() create) {
    return ProviderOverride(
      origin: this,
      override: AnswerCardExpandedProvider._internal(
        () => create()..questionId = questionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        questionId: questionId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AnswerCardExpanded, bool> createElement() {
    return _AnswerCardExpandedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnswerCardExpandedProvider &&
        other.questionId == questionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, questionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnswerCardExpandedRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `questionId` of this provider.
  String get questionId;
}

class _AnswerCardExpandedProviderElement
    extends AutoDisposeNotifierProviderElement<AnswerCardExpanded, bool>
    with AnswerCardExpandedRef {
  _AnswerCardExpandedProviderElement(super.provider);

  @override
  String get questionId => (origin as AnswerCardExpandedProvider).questionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
