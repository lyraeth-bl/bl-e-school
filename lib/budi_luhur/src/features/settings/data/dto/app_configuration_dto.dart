import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_configuration_dto.freezed.dart';
part 'app_configuration_dto.g.dart';

@freezed
abstract class AppConfigurationDTO with _$AppConfigurationDTO {
  const factory AppConfigurationDTO({
    required AppConfiguration appConfiguration,
  }) = _AppConfigurationDTO;

  factory AppConfigurationDTO.fromJson(Map<String, dynamic> json) =>
      _$AppConfigurationDTOFromJson(json);
}
