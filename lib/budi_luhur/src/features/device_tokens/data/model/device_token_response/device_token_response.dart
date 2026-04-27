import 'package:freezed_annotation/freezed_annotation.dart';

import '../device_token.dart';

part 'device_token_response.freezed.dart';

part 'device_token_response.g.dart';

@freezed
abstract class DeviceTokenResponse with _$DeviceTokenResponse {
  const factory DeviceTokenResponse({
    required bool error,
    required String message,
    @JsonKey(name: "data") required DeviceToken deviceToken,
  }) = _DeviceTokenResponse;

  factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenResponseFromJson(json);
}
