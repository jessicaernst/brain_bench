// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'displayed_category_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DisplayedCategoryInfo {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;

  /// Create a copy of DisplayedCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DisplayedCategoryInfoCopyWith<DisplayedCategoryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayedCategoryInfoCopyWith<$Res> {
  factory $DisplayedCategoryInfoCopyWith(
    DisplayedCategoryInfo value,
    $Res Function(DisplayedCategoryInfo) then,
  ) = _$DisplayedCategoryInfoCopyWithImpl<$Res, DisplayedCategoryInfo>;
  @useResult
  $Res call({String name, String description, double progress});
}

/// @nodoc
class _$DisplayedCategoryInfoCopyWithImpl<
  $Res,
  $Val extends DisplayedCategoryInfo
>
    implements $DisplayedCategoryInfoCopyWith<$Res> {
  _$DisplayedCategoryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DisplayedCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            progress:
                null == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DisplayedCategoryInfoImplCopyWith<$Res>
    implements $DisplayedCategoryInfoCopyWith<$Res> {
  factory _$$DisplayedCategoryInfoImplCopyWith(
    _$DisplayedCategoryInfoImpl value,
    $Res Function(_$DisplayedCategoryInfoImpl) then,
  ) = __$$DisplayedCategoryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String description, double progress});
}

/// @nodoc
class __$$DisplayedCategoryInfoImplCopyWithImpl<$Res>
    extends
        _$DisplayedCategoryInfoCopyWithImpl<$Res, _$DisplayedCategoryInfoImpl>
    implements _$$DisplayedCategoryInfoImplCopyWith<$Res> {
  __$$DisplayedCategoryInfoImplCopyWithImpl(
    _$DisplayedCategoryInfoImpl _value,
    $Res Function(_$DisplayedCategoryInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DisplayedCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? progress = null,
  }) {
    return _then(
      _$DisplayedCategoryInfoImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

class _$DisplayedCategoryInfoImpl extends _DisplayedCategoryInfo {
  const _$DisplayedCategoryInfoImpl({
    required this.name,
    required this.description,
    required this.progress,
  }) : super._();

  @override
  final String name;
  @override
  final String description;
  @override
  final double progress;

  @override
  String toString() {
    return 'DisplayedCategoryInfo(name: $name, description: $description, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisplayedCategoryInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, description, progress);

  /// Create a copy of DisplayedCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DisplayedCategoryInfoImplCopyWith<_$DisplayedCategoryInfoImpl>
  get copyWith =>
      __$$DisplayedCategoryInfoImplCopyWithImpl<_$DisplayedCategoryInfoImpl>(
        this,
        _$identity,
      );
}

abstract class _DisplayedCategoryInfo extends DisplayedCategoryInfo {
  const factory _DisplayedCategoryInfo({
    required final String name,
    required final String description,
    required final double progress,
  }) = _$DisplayedCategoryInfoImpl;
  const _DisplayedCategoryInfo._() : super._();

  @override
  String get name;
  @override
  String get description;
  @override
  double get progress;

  /// Create a copy of DisplayedCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DisplayedCategoryInfoImplCopyWith<_$DisplayedCategoryInfoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
