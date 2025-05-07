// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserModelState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(AppUser user) data,
    required TResult Function(String uid, String message) error,
    required TResult Function() unauthenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(AppUser user)? data,
    TResult? Function(String uid, String message)? error,
    TResult? Function()? unauthenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(AppUser user)? data,
    TResult Function(String uid, String message)? error,
    TResult Function()? unauthenticated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelLoading value) loading,
    required TResult Function(UserModelData value) data,
    required TResult Function(UserModelError value) error,
    required TResult Function(UserModelUnauthenticated value) unauthenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelLoading value)? loading,
    TResult? Function(UserModelData value)? data,
    TResult? Function(UserModelError value)? error,
    TResult? Function(UserModelUnauthenticated value)? unauthenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelLoading value)? loading,
    TResult Function(UserModelData value)? data,
    TResult Function(UserModelError value)? error,
    TResult Function(UserModelUnauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelStateCopyWith<$Res> {
  factory $UserModelStateCopyWith(
    UserModelState value,
    $Res Function(UserModelState) then,
  ) = _$UserModelStateCopyWithImpl<$Res, UserModelState>;
}

/// @nodoc
class _$UserModelStateCopyWithImpl<$Res, $Val extends UserModelState>
    implements $UserModelStateCopyWith<$Res> {
  _$UserModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserModelLoadingImplCopyWith<$Res> {
  factory _$$UserModelLoadingImplCopyWith(
    _$UserModelLoadingImpl value,
    $Res Function(_$UserModelLoadingImpl) then,
  ) = __$$UserModelLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserModelLoadingImplCopyWithImpl<$Res>
    extends _$UserModelStateCopyWithImpl<$Res, _$UserModelLoadingImpl>
    implements _$$UserModelLoadingImplCopyWith<$Res> {
  __$$UserModelLoadingImplCopyWithImpl(
    _$UserModelLoadingImpl _value,
    $Res Function(_$UserModelLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserModelLoadingImpl implements UserModelLoading {
  const _$UserModelLoadingImpl();

  @override
  String toString() {
    return 'UserModelState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserModelLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(AppUser user) data,
    required TResult Function(String uid, String message) error,
    required TResult Function() unauthenticated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(AppUser user)? data,
    TResult? Function(String uid, String message)? error,
    TResult? Function()? unauthenticated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(AppUser user)? data,
    TResult Function(String uid, String message)? error,
    TResult Function()? unauthenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelLoading value) loading,
    required TResult Function(UserModelData value) data,
    required TResult Function(UserModelError value) error,
    required TResult Function(UserModelUnauthenticated value) unauthenticated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelLoading value)? loading,
    TResult? Function(UserModelData value)? data,
    TResult? Function(UserModelError value)? error,
    TResult? Function(UserModelUnauthenticated value)? unauthenticated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelLoading value)? loading,
    TResult Function(UserModelData value)? data,
    TResult Function(UserModelError value)? error,
    TResult Function(UserModelUnauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class UserModelLoading implements UserModelState {
  const factory UserModelLoading() = _$UserModelLoadingImpl;
}

/// @nodoc
abstract class _$$UserModelDataImplCopyWith<$Res> {
  factory _$$UserModelDataImplCopyWith(
    _$UserModelDataImpl value,
    $Res Function(_$UserModelDataImpl) then,
  ) = __$$UserModelDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppUser user});

  $AppUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$UserModelDataImplCopyWithImpl<$Res>
    extends _$UserModelStateCopyWithImpl<$Res, _$UserModelDataImpl>
    implements _$$UserModelDataImplCopyWith<$Res> {
  __$$UserModelDataImplCopyWithImpl(
    _$UserModelDataImpl _value,
    $Res Function(_$UserModelDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$UserModelDataImpl(
        null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                as AppUser,
      ),
    );
  }

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<$Res> get user {
    return $AppUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$UserModelDataImpl implements UserModelData {
  const _$UserModelDataImpl(this.user);

  @override
  final AppUser user;

  @override
  String toString() {
    return 'UserModelState.data(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelDataImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelDataImplCopyWith<_$UserModelDataImpl> get copyWith =>
      __$$UserModelDataImplCopyWithImpl<_$UserModelDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(AppUser user) data,
    required TResult Function(String uid, String message) error,
    required TResult Function() unauthenticated,
  }) {
    return data(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(AppUser user)? data,
    TResult? Function(String uid, String message)? error,
    TResult? Function()? unauthenticated,
  }) {
    return data?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(AppUser user)? data,
    TResult Function(String uid, String message)? error,
    TResult Function()? unauthenticated,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelLoading value) loading,
    required TResult Function(UserModelData value) data,
    required TResult Function(UserModelError value) error,
    required TResult Function(UserModelUnauthenticated value) unauthenticated,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelLoading value)? loading,
    TResult? Function(UserModelData value)? data,
    TResult? Function(UserModelError value)? error,
    TResult? Function(UserModelUnauthenticated value)? unauthenticated,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelLoading value)? loading,
    TResult Function(UserModelData value)? data,
    TResult Function(UserModelError value)? error,
    TResult Function(UserModelUnauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class UserModelData implements UserModelState {
  const factory UserModelData(final AppUser user) = _$UserModelDataImpl;

  AppUser get user;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelDataImplCopyWith<_$UserModelDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserModelErrorImplCopyWith<$Res> {
  factory _$$UserModelErrorImplCopyWith(
    _$UserModelErrorImpl value,
    $Res Function(_$UserModelErrorImpl) then,
  ) = __$$UserModelErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String uid, String message});
}

/// @nodoc
class __$$UserModelErrorImplCopyWithImpl<$Res>
    extends _$UserModelStateCopyWithImpl<$Res, _$UserModelErrorImpl>
    implements _$$UserModelErrorImplCopyWith<$Res> {
  __$$UserModelErrorImplCopyWithImpl(
    _$UserModelErrorImpl _value,
    $Res Function(_$UserModelErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uid = null, Object? message = null}) {
    return _then(
      _$UserModelErrorImpl(
        uid:
            null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                    as String,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$UserModelErrorImpl implements UserModelError {
  const _$UserModelErrorImpl({required this.uid, required this.message});

  @override
  final String uid;
  @override
  final String message;

  @override
  String toString() {
    return 'UserModelState.error(uid: $uid, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelErrorImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, message);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelErrorImplCopyWith<_$UserModelErrorImpl> get copyWith =>
      __$$UserModelErrorImplCopyWithImpl<_$UserModelErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(AppUser user) data,
    required TResult Function(String uid, String message) error,
    required TResult Function() unauthenticated,
  }) {
    return error(uid, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(AppUser user)? data,
    TResult? Function(String uid, String message)? error,
    TResult? Function()? unauthenticated,
  }) {
    return error?.call(uid, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(AppUser user)? data,
    TResult Function(String uid, String message)? error,
    TResult Function()? unauthenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(uid, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelLoading value) loading,
    required TResult Function(UserModelData value) data,
    required TResult Function(UserModelError value) error,
    required TResult Function(UserModelUnauthenticated value) unauthenticated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelLoading value)? loading,
    TResult? Function(UserModelData value)? data,
    TResult? Function(UserModelError value)? error,
    TResult? Function(UserModelUnauthenticated value)? unauthenticated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelLoading value)? loading,
    TResult Function(UserModelData value)? data,
    TResult Function(UserModelError value)? error,
    TResult Function(UserModelUnauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UserModelError implements UserModelState {
  const factory UserModelError({
    required final String uid,
    required final String message,
  }) = _$UserModelErrorImpl;

  String get uid;
  String get message;

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelErrorImplCopyWith<_$UserModelErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserModelUnauthenticatedImplCopyWith<$Res> {
  factory _$$UserModelUnauthenticatedImplCopyWith(
    _$UserModelUnauthenticatedImpl value,
    $Res Function(_$UserModelUnauthenticatedImpl) then,
  ) = __$$UserModelUnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserModelUnauthenticatedImplCopyWithImpl<$Res>
    extends _$UserModelStateCopyWithImpl<$Res, _$UserModelUnauthenticatedImpl>
    implements _$$UserModelUnauthenticatedImplCopyWith<$Res> {
  __$$UserModelUnauthenticatedImplCopyWithImpl(
    _$UserModelUnauthenticatedImpl _value,
    $Res Function(_$UserModelUnauthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModelState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserModelUnauthenticatedImpl implements UserModelUnauthenticated {
  const _$UserModelUnauthenticatedImpl();

  @override
  String toString() {
    return 'UserModelState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelUnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(AppUser user) data,
    required TResult Function(String uid, String message) error,
    required TResult Function() unauthenticated,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(AppUser user)? data,
    TResult? Function(String uid, String message)? error,
    TResult? Function()? unauthenticated,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(AppUser user)? data,
    TResult Function(String uid, String message)? error,
    TResult Function()? unauthenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserModelLoading value) loading,
    required TResult Function(UserModelData value) data,
    required TResult Function(UserModelError value) error,
    required TResult Function(UserModelUnauthenticated value) unauthenticated,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserModelLoading value)? loading,
    TResult? Function(UserModelData value)? data,
    TResult? Function(UserModelError value)? error,
    TResult? Function(UserModelUnauthenticated value)? unauthenticated,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserModelLoading value)? loading,
    TResult Function(UserModelData value)? data,
    TResult Function(UserModelError value)? error,
    TResult Function(UserModelUnauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class UserModelUnauthenticated implements UserModelState {
  const factory UserModelUnauthenticated() = _$UserModelUnauthenticatedImpl;
}
