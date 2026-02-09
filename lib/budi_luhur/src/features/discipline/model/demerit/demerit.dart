import 'package:freezed_annotation/freezed_annotation.dart';

part 'demerit.freezed.dart';
part 'demerit.g.dart';

@freezed
abstract class Demerit with _$Demerit {
  const factory Demerit({
    required int id,
    @JsonKey(name: "id_demerit") required int demeritId,
    @JsonKey(name: "Pelanggaran") required String description,
    @JsonKey(name: "Point") required int point,
    @JsonKey(name: "Tanggal") required DateTime date,
    @JsonKey(name: "NIP") required String nip,
    @JsonKey(name: "NIS") required String nis,
    @JsonKey(name: "Tajaran") required String schoolSession,
    @JsonKey(name: "Semester") required String semester,
    @JsonKey(name: "nama_guru") required String teacherName,
    String? unit,
  }) = _Demerit;

  factory Demerit.fromJson(Map<String, dynamic> json) =>
      _$DemeritFromJson(json);
}
