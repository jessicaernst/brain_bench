import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
class SelectedHomeCategory extends _$SelectedHomeCategory {
  @override
  String? build() {
    return null;
  }

  void update(String categoryId) {
    state = categoryId;
  }
}
