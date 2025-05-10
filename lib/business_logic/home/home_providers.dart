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
