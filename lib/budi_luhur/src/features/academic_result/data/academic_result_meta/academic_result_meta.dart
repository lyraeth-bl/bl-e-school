import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_meta.freezed.dart';
part 'academic_result_meta.g.dart';

@freezed
abstract class AcademicResultMeta with _$AcademicResultMeta {
  const factory AcademicResultMeta({
    @JsonKey(name: 'semester') required int semester,
    @JsonKey(name: 'tahun_ajaran') required String schoolSession,
  }) = _AcademicResultMeta;

  factory AcademicResultMeta.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultMetaFromJson(json);
}
