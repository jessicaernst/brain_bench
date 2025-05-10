import 'package:freezed_annotation/freezed_annotation.dart';

part 'displayed_category_info.freezed.dart';

/// Represents the information of a displayed category.
@freezed
class DisplayedCategoryInfo with _$DisplayedCategoryInfo {
  const DisplayedCategoryInfo._();

  /// Creates a [DisplayedCategoryInfo] with the specified [name], [description], and [progress].
  const factory DisplayedCategoryInfo({
    required String name,
    required String description,
    required double progress,
  }) = _DisplayedCategoryInfo;
}
