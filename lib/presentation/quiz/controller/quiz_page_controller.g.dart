// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizPageControllerHash() =>
    r'b22ed737d1fda3e3296ae1d2557a40c3a33fd071';

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

abstract class _$QuizPageController extends BuildlessNotifier<void> {
  late final String topicId;
  late final String categoryId;

  void build({
    required String topicId,
    required String categoryId,
  });
}

/// Handles UI logic and interactions for the QuizPage.
///
/// Copied from [QuizPageController].
@ProviderFor(QuizPageController)
const quizPageControllerProvider = QuizPageControllerFamily();

/// Handles UI logic and interactions for the QuizPage.
///
/// Copied from [QuizPageController].
class QuizPageControllerFamily extends Family<void> {
  /// Handles UI logic and interactions for the QuizPage.
  ///
  /// Copied from [QuizPageController].
  const QuizPageControllerFamily();

  /// Handles UI logic and interactions for the QuizPage.
  ///
  /// Copied from [QuizPageController].
  QuizPageControllerProvider call({
    required String topicId,
    required String categoryId,
  }) {
    return QuizPageControllerProvider(
      topicId: topicId,
      categoryId: categoryId,
    );
  }

  @override
  QuizPageControllerProvider getProviderOverride(
    covariant QuizPageControllerProvider provider,
  ) {
    return call(
      topicId: provider.topicId,
      categoryId: provider.categoryId,
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
  String? get name => r'quizPageControllerProvider';
}

/// Handles UI logic and interactions for the QuizPage.
///
/// Copied from [QuizPageController].
class QuizPageControllerProvider
    extends NotifierProviderImpl<QuizPageController, void> {
  /// Handles UI logic and interactions for the QuizPage.
  ///
  /// Copied from [QuizPageController].
  QuizPageControllerProvider({
    required String topicId,
    required String categoryId,
  }) : this._internal(
          () => QuizPageController()
            ..topicId = topicId
            ..categoryId = categoryId,
          from: quizPageControllerProvider,
          name: r'quizPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizPageControllerHash,
          dependencies: QuizPageControllerFamily._dependencies,
          allTransitiveDependencies:
              QuizPageControllerFamily._allTransitiveDependencies,
          topicId: topicId,
          categoryId: categoryId,
        );

  QuizPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
    required this.categoryId,
  }) : super.internal();

  final String topicId;
  final String categoryId;

  @override
  void runNotifierBuild(
    covariant QuizPageController notifier,
  ) {
    return notifier.build(
      topicId: topicId,
      categoryId: categoryId,
    );
  }

  @override
  Override overrideWith(QuizPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizPageControllerProvider._internal(
        () => create()
          ..topicId = topicId
          ..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
        categoryId: categoryId,
      ),
    );
  }

  @override
  NotifierProviderElement<QuizPageController, void> createElement() {
    return _QuizPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizPageControllerProvider &&
        other.topicId == topicId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizPageControllerRef on NotifierProviderRef<void> {
  /// The parameter `topicId` of this provider.
  String get topicId;

  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _QuizPageControllerProviderElement
    extends NotifierProviderElement<QuizPageController, void>
    with QuizPageControllerRef {
  _QuizPageControllerProviderElement(super.provider);

  @override
  String get topicId => (origin as QuizPageControllerProvider).topicId;
  @override
  String get categoryId => (origin as QuizPageControllerProvider).categoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
