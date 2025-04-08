import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String uid,
    String? profileImageUrl,
    @Default('system') String themeMode,
    @Default('en') String language,
    @Default({}) Map<String, double> categoryProgress,
    @Default({}) Map<String, Map<String, bool>> isTopicDone,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
