import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_table.freezed.dart';
part 'time_table.g.dart';

@freezed
abstract class TimeTable with _$TimeTable {
  const factory TimeTable({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'nm_kelas') required String kelas,
    @JsonKey(name: 'jam_ke') required String jamKe,
    @JsonKey(name: 'awal') required String jamMulai,
    @JsonKey(name: 'akhir') required String jamSelesai,
    @JsonKey(name: 'hari') required String hari,
    @JsonKey(name: 'nama_guru') required String namaGuru,
    @JsonKey(name: 'nama_mapel') required String namaMataPelajaran,
    @JsonKey(name: 'kode_mapel') required String kodeMataPelajaran,
  }) = _TimeTable;

  factory TimeTable.fromJson(Map<String, dynamic> json) =>
      _$TimeTableFromJson(json);
}
