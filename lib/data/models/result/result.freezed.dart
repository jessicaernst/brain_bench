// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Result _$ResultFromJson(Map<String, dynamic> json) {
  return _Result.fromJson(json);
}

/// @nodoc
mixin _$Result {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  int get correct => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  bool get isPassed => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<QuizAnswer> get quizAnswers => throw _privateConstructorUsedError;

  /// Serializes this Result to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultCopyWith<Result> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<$Res> {
  factory $ResultCopyWith(Result value, $Res Function(Result) then) =
      _$ResultCopyWithImpl<$Res, Result>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String topicId,
      String categoryId,
      int correct,
      int total,
      double score,
      bool isPassed,
      DateTime timestamp,
      List<QuizAnswer> quizAnswers});
}

/// @nodoc
class _$ResultCopyWithImpl<$Res, $Val extends Result>
    implements $ResultCopyWith<$Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? categoryId = null,
    Object? correct = null,
    Object? total = null,
    Object? score = null,
    Object? isPassed = null,
    Object? timestamp = null,
    Object? quizAnswers = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      correct: null == correct
          ? _value.correct
          : correct // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quizAnswers: null == quizAnswers
          ? _value.quizAnswers
          : quizAnswers // ignore: cast_nullable_to_non_nullable
              as List<QuizAnswer>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResultImplCopyWith<$Res> implements $ResultCopyWith<$Res> {
  factory _$$ResultImplCopyWith(
          _$ResultImpl value, $Res Function(_$ResultImpl) then) =
      __$$ResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String topicId,
      String categoryId,
      int correct,
      int total,
      double score,
      bool isPassed,
      DateTime timestamp,
      List<QuizAnswer> quizAnswers});
}

/// @nodoc
class __$$ResultImplCopyWithImpl<$Res>
    extends _$ResultCopyWithImpl<$Res, _$ResultImpl>
    implements _$$ResultImplCopyWith<$Res> {
  __$$ResultImplCopyWithImpl(
      _$ResultImpl _value, $Res Function(_$ResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? categoryId = null,
    Object? correct = null,
    Object? total = null,
    Object? score = null,
    Object? isPassed = null,
    Object? timestamp = null,
    Object? quizAnswers = null,
  }) {
    return _then(_$ResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      correct: null == correct
          ? _value.correct
          : correct // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quizAnswers: null == quizAnswers
          ? _value._quizAnswers
          : quizAnswers // ignore: cast_nullable_to_non_nullable
              as List<QuizAnswer>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ResultImpl implements _Result {
  const _$ResultImpl(
      {required this.id,
      required this.userId,
      required this.topicId,
      required this.categoryId,
      required this.correct,
      required this.total,
      required this.score,
      required this.isPassed,
      required this.timestamp,
      required final List<QuizAnswer> quizAnswers})
      : _quizAnswers = quizAnswers;

  factory _$ResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String topicId;
  @override
  final String categoryId;
  @override
  final int correct;
  @override
  final int total;
  @override
  final double score;
  @override
  final bool isPassed;
  @override
  final DateTime timestamp;
  final List<QuizAnswer> _quizAnswers;
  @override
  List<QuizAnswer> get quizAnswers {
    if (_quizAnswers is EqualUnmodifiableListView) return _quizAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quizAnswers);
  }

  @override
  String toString() {
    return 'Result(id: $id, userId: $userId, topicId: $topicId, categoryId: $categoryId, correct: $correct, total: $total, score: $score, isPassed: $isPassed, timestamp: $timestamp, quizAnswers: $quizAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.correct, correct) || other.correct == correct) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.isPassed, isPassed) ||
                other.isPassed == isPassed) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._quizAnswers, _quizAnswers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      topicId,
      categoryId,
      correct,
      total,
      score,
      isPassed,
      timestamp,
      const DeepCollectionEquality().hash(_quizAnswers));

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      __$$ResultImplCopyWithImpl<_$ResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResultImplToJson(
      this,
    );
  }
}

abstract class _Result implements Result {
  const factory _Result(
      {required final String id,
      required final String userId,
      required final String topicId,
      required final String categoryId,
      required final int correct,
      required final int total,
      required final double score,
      required final bool isPassed,
      required final DateTime timestamp,
      required final List<QuizAnswer> quizAnswers}) = _$ResultImpl;

  factory _Result.fromJson(Map<String, dynamic> json) = _$ResultImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get topicId;
  @override
  String get categoryId;
  @override
  int get correct;
  @override
  int get total;
  @override
  double get score;
  @override
  bool get isPassed;
  @override
  DateTime get timestamp;
  @override
  List<QuizAnswer> get quizAnswers;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
