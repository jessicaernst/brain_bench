import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    String? profileImageUrl,
    @Default('system') String themeMode,
    @Default('en') String language,
    @Default({}) Map<String, double> categoryProgress,
    @Default({}) Map<String, Map<String, bool>> isTopicDone,
    required String id,
    String? lastPlayedCategoryId,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
