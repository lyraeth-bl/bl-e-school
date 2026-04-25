import 'package:freezed_annotation/freezed_annotation.dart';

import '../academic_result_categories/academic_result_categories.dart';
import '../academic_result_overall_summary/academic_result_overall_summary.dart';

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
