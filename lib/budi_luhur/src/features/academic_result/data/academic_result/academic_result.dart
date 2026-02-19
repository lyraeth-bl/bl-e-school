import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result.freezed.dart';
part 'academic_result.g.dart';

@freezed
abstract class AcademicResult with _$AcademicResult {
  const factory AcademicResult({
    /// ID dari Data
    required int id,

    /// NIS Siswa/i.
    @JsonKey(name: "NIS") required String nis,

    /// Kelas Siswa
    @JsonKey(name: "Kelas") required String kelas,

    /// Nomor Kelas Siswa
    @JsonKey(name: "NomorKelas") required String nomorKelas,

    /// Nilai
    @JsonKey(name: "Nilai") required int nilai,

    /// Urutan nilai keberapa.
    /// contohnya :
    /// Nilai ulangan harian ke-1.
    /// Nilai ulangan harian ke-2.
    @JsonKey(name: "Deskripsi") required int nilaiKe,

    /// Tanggal pengambilan nilai.
    @JsonKey(name: "Tanggal") required DateTime tanggal,

    /// Aspek nilai.
    @JsonKey(name: "AspekNilai") required String aspekNilai,

    /// Flag remedial.
    /// jika '-', berarti siswa/i tidak remedial, jika "1", berarti remedial
    @JsonKey(name: "Remedial") required String remedial,

    /// Tahun ajaran.
    @JsonKey(name: "Tajaran") required String tajaran,

    /// Semester
    @JsonKey(name: "Semester") required String semester,

    /// Keterangan atau deskripsi dari pengambilan nilai.
    @JsonKey(name: "Keterangan") required String keterangan,

    /// Jenis dari nilai
    @JsonKey(name: "jenis_nilai") required String jenisNilai,

    /// Unit
    String? unit,
  }) = _AcademicResult;

  factory AcademicResult.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultFromJson(json);
}
