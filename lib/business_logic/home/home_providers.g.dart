// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedHomeCategoryHash() =>
    r'e6336392e8ef8c1b05b790dddae05564ab7d2bc0';

/// Provider class for managing the selected home category.
///
/// Copied from [SelectedHomeCategory].
@ProviderFor(SelectedHomeCategory)
final selectedHomeCategoryProvider =
    AutoDisposeNotifierProvider<SelectedHomeCategory, String?>.internal(
      SelectedHomeCategory.new,
      name: r'selectedHomeCategoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedHomeCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedHomeCategory = AutoDisposeNotifier<String?>;
String _$activeCarouselIndexHash() =>
    r'0ed3cabab09d00e2fee3df73178e93a8877d7059';

/// Provider class for managing the active index in the home page articles carousel.
/// This helps in persisting the active card when navigating back.
///
/// Copied from [ActiveCarouselIndex].
@ProviderFor(ActiveCarouselIndex)
final activeCarouselIndexProvider =
    AutoDisposeNotifierProvider<ActiveCarouselIndex, int>.internal(
      ActiveCarouselIndex.new,
      name: r'activeCarouselIndexProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeCarouselIndexHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveCarouselIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
