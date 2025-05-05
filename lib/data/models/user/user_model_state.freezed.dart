// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModelState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserModelState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserModelState()';
  }
}

/// @nodoc
class $UserModelStateCopyWith<$Res> {
  $UserModelStateCopyWith(UserModelState _, $Res Function(UserModelState) __);
}

/// @nodoc

class UserModelLoading implements UserModelState {
  const UserModelLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserModelLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserModelState.loading()';
  }
}

/// @nodoc

class UserModelData implements UserModelState {
  const UserModelData(this.user);

  final AppUser user;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelDataCopyWith<UserModelData> get copyWith =>
      _$UserModelDataCopyWithImpl<UserModelData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModelData &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'UserModelState.data(user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserModelDataCopyWith<$Res>
    implements $UserModelStateCopyWith<$Res> {
  factory $UserModelDataCopyWith(
          UserModelData value, $Res Function(UserModelData) _then) =
      _$UserModelDataCopyWithImpl;
  @useResult
  $Res call({AppUser user});

  $AppUserCopyWith<$Res> get user;
}

/// @nodoc
class _$UserModelDataCopyWithImpl<$Res>
    implements $UserModelDataCopyWith<$Res> {
  _$UserModelDataCopyWithImpl(this._self, this._then);

  final UserModelData _self;
  final $Res Function(UserModelData) _then;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(UserModelData(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AppUser,
    ));
  }

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<$Res> get user {
    return $AppUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class UserModelError implements UserModelState {
  const UserModelError({required this.uid, required this.message});

  final String uid;
  final String message;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelErrorCopyWith<UserModelError> get copyWith =>
      _$UserModelErrorCopyWithImpl<UserModelError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModelError &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, message);

  @override
  String toString() {
    return 'UserModelState.error(uid: $uid, message: $message)';
  }
}

/// @nodoc
abstract mixin class $UserModelErrorCopyWith<$Res>
    implements $UserModelStateCopyWith<$Res> {
  factory $UserModelErrorCopyWith(
          UserModelError value, $Res Function(UserModelError) _then) =
      _$UserModelErrorCopyWithImpl;
  @useResult
  $Res call({String uid, String message});
}

/// @nodoc
class _$UserModelErrorCopyWithImpl<$Res>
    implements $UserModelErrorCopyWith<$Res> {
  _$UserModelErrorCopyWithImpl(this._self, this._then);

  final UserModelError _self;
  final $Res Function(UserModelError) _then;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? message = null,
  }) {
    return _then(UserModelError(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class UserModelUnauthenticated implements UserModelState {
  const UserModelUnauthenticated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserModelUnauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserModelState.unauthenticated()';
  }
}

// dart format on
