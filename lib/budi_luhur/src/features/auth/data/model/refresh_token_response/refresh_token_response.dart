import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response.freezed.dart';
part 'refresh_token_response.g.dart';

/// Represents the response from a refresh token request.
@freezed
abstract class RefreshTokenResponse with _$RefreshTokenResponse {
  /// Creates a new [RefreshTokenResponse].
  const factory RefreshTokenResponse({
    /// The new JWT access token.
    @JsonKey(name: "access_token") required String jwtToken,

    /// The number of seconds until the access token expires.
    @JsonKey(name: "expires_in") int? expiredIn,
  }) = _RefreshTokenResponse;

  /// Creates a new [RefreshTokenResponse] from a JSON object.
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
