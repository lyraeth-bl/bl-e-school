import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_overall_summary.freezed.dart';
part 'academic_result_overall_summary.g.dart';

@freezed
abstract class AcademicResultOverallSummary
    with _$AcademicResultOverallSummary {
  const factory AcademicResultOverallSummary({
    required double average,
    @JsonKey(name: "nilai_akhir_sumatif") required double sumatifAverage,
    @JsonKey(name: "nilai_rapor") required double raporAverage,
    @JsonKey(name: "nilai_rapor_semester") required double raporSemesterAverage,
    @JsonKey(name: "total_penilaian") required int totalData,
  }) = _AcademicResultOverallSummary;

  factory AcademicResultOverallSummary.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultOverallSummaryFromJson(json);
}
