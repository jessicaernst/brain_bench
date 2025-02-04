// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicCardStateHash() => r'e06dd41456dd492d3f3b1cf1445d0dd6478c6efb';

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

abstract class _$TopicCardState extends BuildlessAutoDisposeNotifier<bool> {
  late final String cardId;

  bool build({
    required String cardId,
  });
}

/// See also [TopicCardState].
@ProviderFor(TopicCardState)
const topicCardStateProvider = TopicCardStateFamily();

/// See also [TopicCardState].
class TopicCardStateFamily extends Family<bool> {
  /// See also [TopicCardState].
  const TopicCardStateFamily();

  /// See also [TopicCardState].
  TopicCardStateProvider call({
    required String cardId,
  }) {
    return TopicCardStateProvider(
      cardId: cardId,
    );
  }

  @override
  TopicCardStateProvider getProviderOverride(
    covariant TopicCardStateProvider provider,
  ) {
    return call(
      cardId: provider.cardId,
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
  String? get name => r'topicCardStateProvider';
}

/// See also [TopicCardState].
class TopicCardStateProvider
    extends AutoDisposeNotifierProviderImpl<TopicCardState, bool> {
  /// See also [TopicCardState].
  TopicCardStateProvider({
    required String cardId,
  }) : this._internal(
          () => TopicCardState()..cardId = cardId,
          from: topicCardStateProvider,
          name: r'topicCardStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topicCardStateHash,
          dependencies: TopicCardStateFamily._dependencies,
          allTransitiveDependencies:
              TopicCardStateFamily._allTransitiveDependencies,
          cardId: cardId,
        );

  TopicCardStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardId,
  }) : super.internal();

  final String cardId;

  @override
  bool runNotifierBuild(
    covariant TopicCardState notifier,
  ) {
    return notifier.build(
      cardId: cardId,
    );
  }

  @override
  Override overrideWith(TopicCardState Function() create) {
    return ProviderOverride(
      origin: this,
      override: TopicCardStateProvider._internal(
        () => create()..cardId = cardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardId: cardId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TopicCardState, bool> createElement() {
    return _TopicCardStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicCardStateProvider && other.cardId == cardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicCardStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `cardId` of this provider.
  String get cardId;
}

class _TopicCardStateProviderElement
    extends AutoDisposeNotifierProviderElement<TopicCardState, bool>
    with TopicCardStateRef {
  _TopicCardStateProviderElement(super.provider);

  @override
  String get cardId => (origin as TopicCardStateProvider).cardId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
