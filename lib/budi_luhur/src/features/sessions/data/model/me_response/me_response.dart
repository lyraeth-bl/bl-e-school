import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_response.freezed.dart';
part 'me_response.g.dart';

@freezed
abstract class MeResponse with _$MeResponse {
  const factory MeResponse({
    required bool error,
    @JsonKey(name: "data") required Student me,
  }) = _MeResponse;

  factory MeResponse.fromJson(Map<String, dynamic> json) =>
      _$MeResponseFromJson(json);
}
