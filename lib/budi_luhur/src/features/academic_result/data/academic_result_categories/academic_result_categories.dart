import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_categories.freezed.dart';
part 'academic_result_categories.g.dart';

@freezed
abstract class AcademicResultCategories with _$AcademicResultCategories {
  const factory AcademicResultCategories({
    @JsonKey(name: "nama_pelajaran") required String subjectName,
    @JsonKey(name: "nama_guru") String? subjectTeacherName,
    @JsonKey(name: "summary") required AcademicResultSummary summary,
    @JsonKey(name: "items") required List<AcademicResult> listResult,
  }) = _AcademicResultCategories;

  factory AcademicResultCategories.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultCategoriesFromJson(json);
}
