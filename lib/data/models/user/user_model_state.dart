import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model_state.freezed.dart';

@freezed
sealed class UserModelState with _$UserModelState {
  const factory UserModelState.loading() = UserModelLoading;
  const factory UserModelState.data(AppUser user) = UserModelData;
  const factory UserModelState.error({
    required String uid,
    required String message,
  }) = UserModelError;
  const factory UserModelState.unauthenticated() = UserModelUnauthenticated;
}
