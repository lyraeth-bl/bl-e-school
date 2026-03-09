import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
