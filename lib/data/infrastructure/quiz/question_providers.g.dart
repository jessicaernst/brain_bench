// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionsHash() => r'c1834ee5a6d513438f144800ebcfb05f8c226d72';

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

/// See also [questions].
@ProviderFor(questions)
const questionsProvider = QuestionsFamily();

/// See also [questions].
class QuestionsFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [questions].
  const QuestionsFamily();

  /// See also [questions].
  QuestionsProvider call(
    String topicId,
    String languageCode,
  ) {
    return QuestionsProvider(
      topicId,
      languageCode,
    );
  }

  @override
  QuestionsProvider getProviderOverride(
    covariant QuestionsProvider provider,
  ) {
    return call(
      provider.topicId,
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
  String? get name => r'questionsProvider';
}

/// See also [questions].
class QuestionsProvider extends AutoDisposeFutureProvider<List<Question>> {
  /// See also [questions].
  QuestionsProvider(
    String topicId,
    String languageCode,
  ) : this._internal(
          (ref) => questions(
            ref as QuestionsRef,
            topicId,
            languageCode,
          ),
          from: questionsProvider,
          name: r'questionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$questionsHash,
          dependencies: QuestionsFamily._dependencies,
          allTransitiveDependencies: QuestionsFamily._allTransitiveDependencies,
          topicId: topicId,
          languageCode: languageCode,
        );

  QuestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
    required this.languageCode,
  }) : super.internal();

  final String topicId;
  final String languageCode;

  @override
  Override overrideWith(
    FutureOr<List<Question>> Function(QuestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestionsProvider._internal(
        (ref) => create(ref as QuestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
        languageCode: languageCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _QuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsProvider &&
        other.topicId == topicId &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);
    hash = _SystemHash.combine(hash, languageCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuestionsRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `topicId` of this provider.
  String get topicId;

  /// The parameter `languageCode` of this provider.
  String get languageCode;
}

class _QuestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>> with QuestionsRef {
  _QuestionsProviderElement(super.provider);

  @override
  String get topicId => (origin as QuestionsProvider).topicId;
  @override
  String get languageCode => (origin as QuestionsProvider).languageCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
