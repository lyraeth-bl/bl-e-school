import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_data.freezed.dart';
part 'academic_result_data.g.dart';

@freezed
abstract class AcademicResultData with _$AcademicResultData {
  const factory AcademicResultData({
    @JsonKey(name: "overall_summary")
    required AcademicResultOverallSummary overallSummaryResult,
    @JsonKey(name: "categories")
    required List<AcademicResultCategories> categories,
  }) = _AcademicResultData;

  factory AcademicResultData.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultDataFromJson(json);
}
