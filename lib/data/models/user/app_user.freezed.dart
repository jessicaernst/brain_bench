// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String get themeMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  Map<String, double> get categoryProgress =>
      throw _privateConstructorUsedError;
  Map<String, Map<String, bool>> get isTopicDone =>
      throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoUrl,
      String? profileImageUrl,
      String themeMode,
      String language,
      Map<String, double> categoryProgress,
      Map<String, Map<String, bool>> isTopicDone,
      String id});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? profileImageUrl = freezed,
    Object? themeMode = null,
    Object? language = null,
    Object? categoryProgress = null,
    Object? isTopicDone = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      categoryProgress: null == categoryProgress
          ? _value.categoryProgress
          : categoryProgress // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      isTopicDone: null == isTopicDone
          ? _value.isTopicDone
          : isTopicDone // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, bool>>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoUrl,
      String? profileImageUrl,
      String themeMode,
      String language,
      Map<String, double> categoryProgress,
      Map<String, Map<String, bool>> isTopicDone,
      String id});
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? profileImageUrl = freezed,
    Object? themeMode = null,
    Object? language = null,
    Object? categoryProgress = null,
    Object? isTopicDone = null,
    Object? id = null,
  }) {
    return _then(_$AppUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      categoryProgress: null == categoryProgress
          ? _value._categoryProgress
          : categoryProgress // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      isTopicDone: null == isTopicDone
          ? _value._isTopicDone
          : isTopicDone // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, bool>>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photoUrl,
      this.profileImageUrl,
      this.themeMode = 'system',
      this.language = 'en',
      final Map<String, double> categoryProgress = const {},
      final Map<String, Map<String, bool>> isTopicDone = const {},
      required this.id})
      : _categoryProgress = categoryProgress,
        _isTopicDone = isTopicDone;

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final String? profileImageUrl;
  @override
  @JsonKey()
  final String themeMode;
  @override
  @JsonKey()
  final String language;
  final Map<String, double> _categoryProgress;
  @override
  @JsonKey()
  Map<String, double> get categoryProgress {
    if (_categoryProgress is EqualUnmodifiableMapView) return _categoryProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryProgress);
  }

  final Map<String, Map<String, bool>> _isTopicDone;
  @override
  @JsonKey()
  Map<String, Map<String, bool>> get isTopicDone {
    if (_isTopicDone is EqualUnmodifiableMapView) return _isTopicDone;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_isTopicDone);
  }

  @override
  final String id;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, profileImageUrl: $profileImageUrl, themeMode: $themeMode, language: $language, categoryProgress: $categoryProgress, isTopicDone: $isTopicDone, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality()
                .equals(other._categoryProgress, _categoryProgress) &&
            const DeepCollectionEquality()
                .equals(other._isTopicDone, _isTopicDone) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      displayName,
      photoUrl,
      profileImageUrl,
      themeMode,
      language,
      const DeepCollectionEquality().hash(_categoryProgress),
      const DeepCollectionEquality().hash(_isTopicDone),
      id);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser(
      {required final String uid,
      required final String email,
      final String? displayName,
      final String? photoUrl,
      final String? profileImageUrl,
      final String themeMode,
      final String language,
      final Map<String, double> categoryProgress,
      final Map<String, Map<String, bool>> isTopicDone,
      required final String id}) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  String? get profileImageUrl;
  @override
  String get themeMode;
  @override
  String get language;
  @override
  Map<String, double> get categoryProgress;
  @override
  Map<String, Map<String, bool>> get isTopicDone;
  @override
  String get id;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
