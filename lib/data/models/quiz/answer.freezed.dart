// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return _Answer.fromJson(json);
}

/// @nodoc
mixin _$Answer {
  String get id => throw _privateConstructorUsedError;
  String get textEn => throw _privateConstructorUsedError;
  String? get textDe => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this Answer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerCopyWith<Answer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res, Answer>;
  @useResult
  $Res call({
    String id,
    String textEn,
    String? textDe,
    bool isCorrect,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isSelected,
  });
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res, $Val extends Answer>
    implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? textEn = null,
    Object? textDe = freezed,
    Object? isCorrect = null,
    Object? isSelected = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            textEn:
                null == textEn
                    ? _value.textEn
                    : textEn // ignore: cast_nullable_to_non_nullable
                        as String,
            textDe:
                freezed == textDe
                    ? _value.textDe
                    : textDe // ignore: cast_nullable_to_non_nullable
                        as String?,
            isCorrect:
                null == isCorrect
                    ? _value.isCorrect
                    : isCorrect // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSelected:
                null == isSelected
                    ? _value.isSelected
                    : isSelected // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnswerImplCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$$AnswerImplCopyWith(
    _$AnswerImpl value,
    $Res Function(_$AnswerImpl) then,
  ) = __$$AnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String textEn,
    String? textDe,
    bool isCorrect,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isSelected,
  });
}

/// @nodoc
class __$$AnswerImplCopyWithImpl<$Res>
    extends _$AnswerCopyWithImpl<$Res, _$AnswerImpl>
    implements _$$AnswerImplCopyWith<$Res> {
  __$$AnswerImplCopyWithImpl(
    _$AnswerImpl _value,
    $Res Function(_$AnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? textEn = null,
    Object? textDe = freezed,
    Object? isCorrect = null,
    Object? isSelected = null,
  }) {
    return _then(
      _$AnswerImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        textEn:
            null == textEn
                ? _value.textEn
                : textEn // ignore: cast_nullable_to_non_nullable
                    as String,
        textDe:
            freezed == textDe
                ? _value.textDe
                : textDe // ignore: cast_nullable_to_non_nullable
                    as String?,
        isCorrect:
            null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSelected:
            null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerImpl implements _Answer {
  const _$AnswerImpl({
    required this.id,
    required this.textEn,
    this.textDe,
    required this.isCorrect,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.isSelected = false,
  });

  factory _$AnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerImplFromJson(json);

  @override
  final String id;
  @override
  final String textEn;
  @override
  final String? textDe;
  @override
  final bool isCorrect;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSelected;

  @override
  String toString() {
    return 'Answer(id: $id, textEn: $textEn, textDe: $textDe, isCorrect: $isCorrect, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.textDe, textDe) || other.textDe == textDe) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, textEn, textDe, isCorrect, isSelected);

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      __$$AnswerImplCopyWithImpl<_$AnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerImplToJson(this);
  }
}

abstract class _Answer implements Answer {
  const factory _Answer({
    required final String id,
    required final String textEn,
    final String? textDe,
    required final bool isCorrect,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final bool isSelected,
  }) = _$AnswerImpl;

  factory _Answer.fromJson(Map<String, dynamic> json) = _$AnswerImpl.fromJson;

  @override
  String get id;
  @override
  String get textEn;
  @override
  String? get textDe;
  @override
  bool get isCorrect;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSelected;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
