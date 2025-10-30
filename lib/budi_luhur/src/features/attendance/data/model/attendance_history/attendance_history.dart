import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_history.freezed.dart';
part 'attendance_history.g.dart';

@freezed
abstract class AttendanceHistory with _$AttendanceHistory {
  /// Creates an [AttendanceHistory] object.
  const factory AttendanceHistory({
    /// The unique identifier for the attendance record.
    @JsonKey(name: "id") required int id,

    /// The student's national identification number (NIS).
    @JsonKey(name: "NIS") required String nis,

    /// The class of the student.
    @JsonKey(name: "Kelas") required String kelas,

    /// The reason for absence.
    @JsonKey(name: "AlasanKetidakhadiran") required String alasanTidakHadir,

    /// Additional notes or description.
    @JsonKey(name: "Keterangan") required String keterangan,

    /// The date of the attendance record.
    @JsonKey(name: "Tanggal") required DateTime tanggal,

    /// The time of late arrival.
    @JsonKey(name: "JamTerlambat") required String jamTerlambat,

    /// The academic year.
    @JsonKey(name: "Tajaran") required String tajaran,

    /// The semester.
    @JsonKey(name: "Semester") required String semester,

    /// The status of the attendance (e.g., Present, Absent, Late).
    @JsonKey(name: "Status") required String status,

    /// The school unit.
    @JsonKey(name: "unit") String? unit,

    /// The name of the student.
    @JsonKey(name: "Nama") String? nama,

    /// The student's current class.
    @JsonKey(name: "KelasSaatIni") String? kelasSaatIni,
  }) = _AttendanceHistory;

  /// Creates an [Attendance] object from a JSON map.
  factory AttendanceHistory.fromJson(Map<String, dynamic> json) =>
      _$AttendanceHistoryFromJson(json);
}
