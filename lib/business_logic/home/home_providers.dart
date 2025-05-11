import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

/// Provider class for managing the selected home category.
@riverpod
class SelectedHomeCategory extends _$SelectedHomeCategory {
  @override
  String? build() {
    return null;
  }

  /// Updates the selected home category with the provided [categoryId].
  void update(String categoryId) {
    state = categoryId;
  }
}

/// Provider class for managing the active index in the home page articles carousel.
/// This helps in persisting the active card when navigating back.
@riverpod
class ActiveCarouselIndex extends _$ActiveCarouselIndex {
  @override
  int build() {
    return 0;
  }

  /// Updates the active carousel index.
  void update(int newIndex) {
    state = newIndex;
  }
}
