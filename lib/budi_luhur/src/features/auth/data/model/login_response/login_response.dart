import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool error,
    required String message,
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "token_type") required String tokenType,
    @JsonKey(name: "expires_at") required DateTime expiresAt,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
