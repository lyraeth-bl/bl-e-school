import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_summary.freezed.dart';
part 'academic_result_summary.g.dart';

@freezed
abstract class AcademicResultSummary with _$AcademicResultSummary {
  const factory AcademicResultSummary({
    required double average,
    @JsonKey(name: 'total_penilaian') required int totalData,
  }) = _AcademicResultSummary;

  factory AcademicResultSummary.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultSummaryFromJson(json);
}
