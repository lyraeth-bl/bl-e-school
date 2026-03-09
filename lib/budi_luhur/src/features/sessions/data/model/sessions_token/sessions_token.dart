import 'package:freezed_annotation/freezed_annotation.dart';

part 'sessions_token.freezed.dart';
part 'sessions_token.g.dart';

@freezed
abstract class SessionsToken with _$SessionsToken {
  const factory SessionsToken({
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "token_type") required String tokenType,
    @JsonKey(name: "expires_at") required DateTime expiresAt,
  }) = _SessionsToken;

  factory SessionsToken.fromJson(Map<String, dynamic> json) =>
      _$SessionsTokenFromJson(json);
}
