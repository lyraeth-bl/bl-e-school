import 'package:freezed_annotation/freezed_annotation.dart';

part 'merit.freezed.dart';
part 'merit.g.dart';

@freezed
abstract class Merit with _$Merit {
  const factory Merit({
    required int id,
    @JsonKey(name: "id_merit") required int meritId,
    @JsonKey(name: "Penghargaan") required String description,
    @JsonKey(name: "Point") required int point,
    @JsonKey(name: "Tanggal") required DateTime date,
    @JsonKey(name: "NIP") required String nip,
    @JsonKey(name: "NIS") required String nis,
    @JsonKey(name: "Tajaran") required String schoolSession,
    @JsonKey(name: "Semester") required String semester,
    @JsonKey(name: "nama_guru") required String teacherName,
    String? unit,
  }) = _Merit;

  factory Merit.fromJson(Map<String, dynamic> json) => _$MeritFromJson(json);
}
