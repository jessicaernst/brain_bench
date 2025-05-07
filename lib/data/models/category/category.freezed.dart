// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get nameDe => throw _privateConstructorUsedError;
  String get subtitleEn => throw _privateConstructorUsedError;
  String get subtitleDe => throw _privateConstructorUsedError;
  String get descriptionEn => throw _privateConstructorUsedError;
  String get descriptionDe => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({
    String id,
    String nameEn,
    String nameDe,
    String subtitleEn,
    String subtitleDe,
    String descriptionEn,
    String descriptionDe,
  });
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameDe = null,
    Object? subtitleEn = null,
    Object? subtitleDe = null,
    Object? descriptionEn = null,
    Object? descriptionDe = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            nameEn:
                null == nameEn
                    ? _value.nameEn
                    : nameEn // ignore: cast_nullable_to_non_nullable
                        as String,
            nameDe:
                null == nameDe
                    ? _value.nameDe
                    : nameDe // ignore: cast_nullable_to_non_nullable
                        as String,
            subtitleEn:
                null == subtitleEn
                    ? _value.subtitleEn
                    : subtitleEn // ignore: cast_nullable_to_non_nullable
                        as String,
            subtitleDe:
                null == subtitleDe
                    ? _value.subtitleDe
                    : subtitleDe // ignore: cast_nullable_to_non_nullable
                        as String,
            descriptionEn:
                null == descriptionEn
                    ? _value.descriptionEn
                    : descriptionEn // ignore: cast_nullable_to_non_nullable
                        as String,
            descriptionDe:
                null == descriptionDe
                    ? _value.descriptionDe
                    : descriptionDe // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nameEn,
    String nameDe,
    String subtitleEn,
    String subtitleDe,
    String descriptionEn,
    String descriptionDe,
  });
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameDe = null,
    Object? subtitleEn = null,
    Object? subtitleDe = null,
    Object? descriptionEn = null,
    Object? descriptionDe = null,
  }) {
    return _then(
      _$CategoryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        nameEn:
            null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                    as String,
        nameDe:
            null == nameDe
                ? _value.nameDe
                : nameDe // ignore: cast_nullable_to_non_nullable
                    as String,
        subtitleEn:
            null == subtitleEn
                ? _value.subtitleEn
                : subtitleEn // ignore: cast_nullable_to_non_nullable
                    as String,
        subtitleDe:
            null == subtitleDe
                ? _value.subtitleDe
                : subtitleDe // ignore: cast_nullable_to_non_nullable
                    as String,
        descriptionEn:
            null == descriptionEn
                ? _value.descriptionEn
                : descriptionEn // ignore: cast_nullable_to_non_nullable
                    as String,
        descriptionDe:
            null == descriptionDe
                ? _value.descriptionDe
                : descriptionDe // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  _$CategoryImpl({
    required this.id,
    required this.nameEn,
    required this.nameDe,
    required this.subtitleEn,
    required this.subtitleDe,
    required this.descriptionEn,
    required this.descriptionDe,
  });

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String nameEn;
  @override
  final String nameDe;
  @override
  final String subtitleEn;
  @override
  final String subtitleDe;
  @override
  final String descriptionEn;
  @override
  final String descriptionDe;

  @override
  String toString() {
    return 'Category(id: $id, nameEn: $nameEn, nameDe: $nameDe, subtitleEn: $subtitleEn, subtitleDe: $subtitleDe, descriptionEn: $descriptionEn, descriptionDe: $descriptionDe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameDe, nameDe) || other.nameDe == nameDe) &&
            (identical(other.subtitleEn, subtitleEn) ||
                other.subtitleEn == subtitleEn) &&
            (identical(other.subtitleDe, subtitleDe) ||
                other.subtitleDe == subtitleDe) &&
            (identical(other.descriptionEn, descriptionEn) ||
                other.descriptionEn == descriptionEn) &&
            (identical(other.descriptionDe, descriptionDe) ||
                other.descriptionDe == descriptionDe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nameEn,
    nameDe,
    subtitleEn,
    subtitleDe,
    descriptionEn,
    descriptionDe,
  );

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(this);
  }
}

abstract class _Category implements Category {
  factory _Category({
    required final String id,
    required final String nameEn,
    required final String nameDe,
    required final String subtitleEn,
    required final String subtitleDe,
    required final String descriptionEn,
    required final String descriptionDe,
  }) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get nameEn;
  @override
  String get nameDe;
  @override
  String get subtitleEn;
  @override
  String get subtitleDe;
  @override
  String get descriptionEn;
  @override
  String get descriptionDe;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
