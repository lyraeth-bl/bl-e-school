import 'package:freezed_annotation/freezed_annotation.dart';

part 'extracurricular.freezed.dart';
part 'extracurricular.g.dart';

@freezed
abstract class Extracurricular with _$Extracurricular {
  const factory Extracurricular({
    required int id,
    @JsonKey(name: "NIS") required String nis,
    @JsonKey(name: "Kelas") required String kelas,
    @JsonKey(name: "NomorKelas") required String nomorKelas,
    @JsonKey(name: "NamaKegiatan") required String namaKegiatan,
    @JsonKey(name: "Tajaran") required String tajaran,
    @JsonKey(name: "Semester") required String semester,
    @JsonKey(name: "Nilai") required String nilai,
    String? unit,
  }) = _Extracurricular;

  factory Extracurricular.fromJson(Map<String, dynamic> json) =>
      _$ExtracurricularFromJson(json);
}
