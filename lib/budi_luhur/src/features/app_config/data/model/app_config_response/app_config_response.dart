import 'package:freezed_annotation/freezed_annotation.dart';

import '../app_config/app_config.dart';

part 'app_config_response.freezed.dart';
part 'app_config_response.g.dart';

@freezed
abstract class AppConfigResponse with _$AppConfigResponse {
  const factory AppConfigResponse({
    required bool error,
    @JsonKey(name: "data") required List<AppConfig> appConfig,
  }) = _AppConfigResponse;

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$AppConfigResponseFromJson(json);
}
