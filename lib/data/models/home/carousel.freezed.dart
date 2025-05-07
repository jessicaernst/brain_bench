// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carousel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Carousel _$CarouselFromJson(Map<String, dynamic> json) {
  return _Carousel.fromJson(json);
}

/// @nodoc
mixin _$Carousel {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this Carousel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Carousel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarouselCopyWith<Carousel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarouselCopyWith<$Res> {
  factory $CarouselCopyWith(Carousel value, $Res Function(Carousel) then) =
      _$CarouselCopyWithImpl<$Res, Carousel>;
  @useResult
  $Res call({
    String id,
    String categoryId,
    String title,
    String description,
    String imageUrl,
  });
}

/// @nodoc
class _$CarouselCopyWithImpl<$Res, $Val extends Carousel>
    implements $CarouselCopyWith<$Res> {
  _$CarouselCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Carousel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryId:
                null == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            imageUrl:
                null == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CarouselImplCopyWith<$Res>
    implements $CarouselCopyWith<$Res> {
  factory _$$CarouselImplCopyWith(
    _$CarouselImpl value,
    $Res Function(_$CarouselImpl) then,
  ) = __$$CarouselImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String categoryId,
    String title,
    String description,
    String imageUrl,
  });
}

/// @nodoc
class __$$CarouselImplCopyWithImpl<$Res>
    extends _$CarouselCopyWithImpl<$Res, _$CarouselImpl>
    implements _$$CarouselImplCopyWith<$Res> {
  __$$CarouselImplCopyWithImpl(
    _$CarouselImpl _value,
    $Res Function(_$CarouselImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Carousel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _$CarouselImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryId:
            null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        imageUrl:
            null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CarouselImpl implements _Carousel {
  const _$CarouselImpl({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory _$CarouselImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarouselImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'Carousel(id: $id, categoryId: $categoryId, title: $title, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarouselImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, categoryId, title, description, imageUrl);

  /// Create a copy of Carousel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarouselImplCopyWith<_$CarouselImpl> get copyWith =>
      __$$CarouselImplCopyWithImpl<_$CarouselImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarouselImplToJson(this);
  }
}

abstract class _Carousel implements Carousel {
  const factory _Carousel({
    required final String id,
    required final String categoryId,
    required final String title,
    required final String description,
    required final String imageUrl,
  }) = _$CarouselImpl;

  factory _Carousel.fromJson(Map<String, dynamic> json) =
      _$CarouselImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;

  /// Create a copy of Carousel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarouselImplCopyWith<_$CarouselImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
