// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizAnswer _$QuizAnswerFromJson(Map<String, dynamic> json) {
  return _QuizAnswer.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswer {
  String get id => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  List<String> get givenAnswers => throw _privateConstructorUsedError;
  List<String> get correctAnswers => throw _privateConstructorUsedError;
  List<String> get incorrectAnswers => throw _privateConstructorUsedError;
  List<String> get allAnswers => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;
  int get possiblePoints => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerCopyWith<QuizAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerCopyWith<$Res> {
  factory $QuizAnswerCopyWith(
    QuizAnswer value,
    $Res Function(QuizAnswer) then,
  ) = _$QuizAnswerCopyWithImpl<$Res, QuizAnswer>;
  @useResult
  $Res call({
    String id,
    String topicId,
    String categoryId,
    String questionId,
    String questionText,
    List<String> givenAnswers,
    List<String> correctAnswers,
    List<String> incorrectAnswers,
    List<String> allAnswers,
    String? explanation,
    int pointsEarned,
    int possiblePoints,
  });
}

/// @nodoc
class _$QuizAnswerCopyWithImpl<$Res, $Val extends QuizAnswer>
    implements $QuizAnswerCopyWith<$Res> {
  _$QuizAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? categoryId = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? givenAnswers = null,
    Object? correctAnswers = null,
    Object? incorrectAnswers = null,
    Object? allAnswers = null,
    Object? explanation = freezed,
    Object? pointsEarned = null,
    Object? possiblePoints = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            topicId:
                null == topicId
                    ? _value.topicId
                    : topicId // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryId:
                null == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            questionId:
                null == questionId
                    ? _value.questionId
                    : questionId // ignore: cast_nullable_to_non_nullable
                        as String,
            questionText:
                null == questionText
                    ? _value.questionText
                    : questionText // ignore: cast_nullable_to_non_nullable
                        as String,
            givenAnswers:
                null == givenAnswers
                    ? _value.givenAnswers
                    : givenAnswers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            correctAnswers:
                null == correctAnswers
                    ? _value.correctAnswers
                    : correctAnswers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            incorrectAnswers:
                null == incorrectAnswers
                    ? _value.incorrectAnswers
                    : incorrectAnswers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            allAnswers:
                null == allAnswers
                    ? _value.allAnswers
                    : allAnswers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            explanation:
                freezed == explanation
                    ? _value.explanation
                    : explanation // ignore: cast_nullable_to_non_nullable
                        as String?,
            pointsEarned:
                null == pointsEarned
                    ? _value.pointsEarned
                    : pointsEarned // ignore: cast_nullable_to_non_nullable
                        as int,
            possiblePoints:
                null == possiblePoints
                    ? _value.possiblePoints
                    : possiblePoints // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerImplCopyWith<$Res>
    implements $QuizAnswerCopyWith<$Res> {
  factory _$$QuizAnswerImplCopyWith(
    _$QuizAnswerImpl value,
    $Res Function(_$QuizAnswerImpl) then,
  ) = __$$QuizAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topicId,
    String categoryId,
    String questionId,
    String questionText,
    List<String> givenAnswers,
    List<String> correctAnswers,
    List<String> incorrectAnswers,
    List<String> allAnswers,
    String? explanation,
    int pointsEarned,
    int possiblePoints,
  });
}

/// @nodoc
class __$$QuizAnswerImplCopyWithImpl<$Res>
    extends _$QuizAnswerCopyWithImpl<$Res, _$QuizAnswerImpl>
    implements _$$QuizAnswerImplCopyWith<$Res> {
  __$$QuizAnswerImplCopyWithImpl(
    _$QuizAnswerImpl _value,
    $Res Function(_$QuizAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? categoryId = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? givenAnswers = null,
    Object? correctAnswers = null,
    Object? incorrectAnswers = null,
    Object? allAnswers = null,
    Object? explanation = freezed,
    Object? pointsEarned = null,
    Object? possiblePoints = null,
  }) {
    return _then(
      _$QuizAnswerImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        topicId:
            null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryId:
            null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        questionId:
            null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                    as String,
        questionText:
            null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                    as String,
        givenAnswers:
            null == givenAnswers
                ? _value._givenAnswers
                : givenAnswers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        correctAnswers:
            null == correctAnswers
                ? _value._correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        incorrectAnswers:
            null == incorrectAnswers
                ? _value._incorrectAnswers
                : incorrectAnswers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        allAnswers:
            null == allAnswers
                ? _value._allAnswers
                : allAnswers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        explanation:
            freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                    as String?,
        pointsEarned:
            null == pointsEarned
                ? _value.pointsEarned
                : pointsEarned // ignore: cast_nullable_to_non_nullable
                    as int,
        possiblePoints:
            null == possiblePoints
                ? _value.possiblePoints
                : possiblePoints // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnswerImpl implements _QuizAnswer {
  _$QuizAnswerImpl({
    required this.id,
    required this.topicId,
    required this.categoryId,
    required this.questionId,
    required this.questionText,
    required final List<String> givenAnswers,
    required final List<String> correctAnswers,
    required final List<String> incorrectAnswers,
    required final List<String> allAnswers,
    this.explanation,
    this.pointsEarned = 0,
    this.possiblePoints = 0,
  }) : _givenAnswers = givenAnswers,
       _correctAnswers = correctAnswers,
       _incorrectAnswers = incorrectAnswers,
       _allAnswers = allAnswers;

  factory _$QuizAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerImplFromJson(json);

  @override
  final String id;
  @override
  final String topicId;
  @override
  final String categoryId;
  @override
  final String questionId;
  @override
  final String questionText;
  final List<String> _givenAnswers;
  @override
  List<String> get givenAnswers {
    if (_givenAnswers is EqualUnmodifiableListView) return _givenAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_givenAnswers);
  }

  final List<String> _correctAnswers;
  @override
  List<String> get correctAnswers {
    if (_correctAnswers is EqualUnmodifiableListView) return _correctAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_correctAnswers);
  }

  final List<String> _incorrectAnswers;
  @override
  List<String> get incorrectAnswers {
    if (_incorrectAnswers is EqualUnmodifiableListView)
      return _incorrectAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incorrectAnswers);
  }

  final List<String> _allAnswers;
  @override
  List<String> get allAnswers {
    if (_allAnswers is EqualUnmodifiableListView) return _allAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allAnswers);
  }

  @override
  final String? explanation;
  @override
  @JsonKey()
  final int pointsEarned;
  @override
  @JsonKey()
  final int possiblePoints;

  @override
  String toString() {
    return 'QuizAnswer(id: $id, topicId: $topicId, categoryId: $categoryId, questionId: $questionId, questionText: $questionText, givenAnswers: $givenAnswers, correctAnswers: $correctAnswers, incorrectAnswers: $incorrectAnswers, allAnswers: $allAnswers, explanation: $explanation, pointsEarned: $pointsEarned, possiblePoints: $possiblePoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            const DeepCollectionEquality().equals(
              other._givenAnswers,
              _givenAnswers,
            ) &&
            const DeepCollectionEquality().equals(
              other._correctAnswers,
              _correctAnswers,
            ) &&
            const DeepCollectionEquality().equals(
              other._incorrectAnswers,
              _incorrectAnswers,
            ) &&
            const DeepCollectionEquality().equals(
              other._allAnswers,
              _allAnswers,
            ) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.possiblePoints, possiblePoints) ||
                other.possiblePoints == possiblePoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    topicId,
    categoryId,
    questionId,
    questionText,
    const DeepCollectionEquality().hash(_givenAnswers),
    const DeepCollectionEquality().hash(_correctAnswers),
    const DeepCollectionEquality().hash(_incorrectAnswers),
    const DeepCollectionEquality().hash(_allAnswers),
    explanation,
    pointsEarned,
    possiblePoints,
  );

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      __$$QuizAnswerImplCopyWithImpl<_$QuizAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerImplToJson(this);
  }
}

abstract class _QuizAnswer implements QuizAnswer {
  factory _QuizAnswer({
    required final String id,
    required final String topicId,
    required final String categoryId,
    required final String questionId,
    required final String questionText,
    required final List<String> givenAnswers,
    required final List<String> correctAnswers,
    required final List<String> incorrectAnswers,
    required final List<String> allAnswers,
    final String? explanation,
    final int pointsEarned,
    final int possiblePoints,
  }) = _$QuizAnswerImpl;

  factory _QuizAnswer.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerImpl.fromJson;

  @override
  String get id;
  @override
  String get topicId;
  @override
  String get categoryId;
  @override
  String get questionId;
  @override
  String get questionText;
  @override
  List<String> get givenAnswers;
  @override
  List<String> get correctAnswers;
  @override
  List<String> get incorrectAnswers;
  @override
  List<String> get allAnswers;
  @override
  String? get explanation;
  @override
  int get pointsEarned;
  @override
  int get possiblePoints;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
