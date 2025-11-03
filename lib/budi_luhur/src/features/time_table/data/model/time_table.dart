import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_table.freezed.dart';
part 'time_table.g.dart';

/// Represents a single entry in the school timetable.
///
/// This model captures the details of a specific class session, including the
/// subject, teacher, time, and classroom. It is used to deserialize data from the
/// API and display the timetable to students and teachers.
@freezed
abstract class TimeTable with _$TimeTable {
  /// Creates an instance of a [TimeTable] entry.
  const factory TimeTable({
    /// The unique identifier for this timetable entry.
    @JsonKey(name: 'id') required String id,

    /// The name of the class or grade (e.g., "X-A", "XII-IPA-2").
    @JsonKey(name: 'nm_kelas') required String kelas,

    /// The class period number (e.g., "1", "2", "3").
    @JsonKey(name: 'jam_ke') required String jamKe,

    /// The start time of the class session (e.g., "07:00").
    @JsonKey(name: 'awal') required String jamMulai,

    /// The end time of the class session (e.g., "08:30").
    @JsonKey(name: 'akhir') required String jamSelesai,

    /// The day of the week for this session (e.g., "Senin", "Selasa").
    @JsonKey(name: 'hari') required String hari,

    /// The name of the teacher conducting the class.
    @JsonKey(name: 'nama_guru') required String namaGuru,

    /// The full name of the subject being taught (e.g., "Matematika", "Bahasa Indonesia").
    @JsonKey(name: 'nama_mapel') required String namaMataPelajaran,

    /// The unique code for the subject (e.g., "MTK-01", "IND-02").
    @JsonKey(name: 'kode_mapel') required String kodeMataPelajaran,
  }) = _TimeTable;

  /// Creates a [TimeTable] instance from a JSON map.
  ///
  /// This factory is used for deserializing the JSON response from the API
  /// into a `TimeTable` object.
  factory TimeTable.fromJson(Map<String, dynamic> json) =>
      _$TimeTableFromJson(json);
}
