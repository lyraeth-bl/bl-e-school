import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_response.freezed.dart';
part 'academic_result_response.g.dart';

@freezed
abstract class AcademicResultResponse with _$AcademicResultResponse {
  const factory AcademicResultResponse({
    required bool error,
    required String message,
    @JsonKey(name: "meta") required AcademicResultMeta meta,
    @JsonKey(name: "data") required AcademicResultData data,
  }) = _AcademicResultResponse;

  factory AcademicResultResponse.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultResponseFromJson(json);
}
