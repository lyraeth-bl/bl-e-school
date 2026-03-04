import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'android_app_link') String? androidAppLink,
    @JsonKey(name: 'ios_app_link') String? iosAppLink,
    @JsonKey(name: 'android_app_version') String? androidAppVersion,
    @JsonKey(name: 'ios_app_version') String? iosAppVersion,
    @JsonKey(name: 'force_app_update') @Default(false) bool forceAppUpdate,
    @JsonKey(name: 'app_maintenance') @Default(false) bool appMaintenance,
    @JsonKey(name: 'file_upload_size_limit') String? fileUploadSizeLimit,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
