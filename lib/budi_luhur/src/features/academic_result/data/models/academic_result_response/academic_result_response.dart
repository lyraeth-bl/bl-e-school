import 'package:freezed_annotation/freezed_annotation.dart';

import '../academic_result_data/academic_result_data.dart';
import '../academic_result_meta/academic_result_meta.dart';

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
