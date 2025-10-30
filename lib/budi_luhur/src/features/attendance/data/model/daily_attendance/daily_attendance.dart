import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_attendance.freezed.dart';
part 'daily_attendance.g.dart';

/// Represents a single daily attendance record for a student.
///
/// This model captures the details of a student's attendance on a specific day,
/// including check-in and check-out times, status (e.g., present, absent, sick),
/// and any accompanying reasons. It is used to deserialize data from the API
/// and manage attendance information within the application.
@freezed
abstract class DailyAttendance with _$DailyAttendance {
  /// Creates an instance of a [DailyAttendance] record.
  const factory DailyAttendance({
    /// The unique identifier for this attendance record.
    @JsonKey(name: "id") required int id,

    /// The student's unique identification number (Nomor Induk Siswa).
    @JsonKey(name: "nis") required String nis,

    /// The date of the attendance record.
    @JsonKey(name: "tanggal") required DateTime tanggal,

    /// The time the student checked in. Can be null if the student has not
    /// checked in yet.
    @JsonKey(name: "checkIn") DateTime? jamCheckIn,

    /// The time the student checked out. Can be null if the student has not
    /// checked out yet.
    @JsonKey(name: "checkOut") DateTime? jamCheckOut,

    /// The attendance status for the day.
    ///
    /// Common values include "Hadir" (Present), "Sakit" (Sick), "Izin" (Permission),
    /// and "Alpa" (Absent without permission).
    @JsonKey(name: "status") required String status,

    /// The reason for absence or tardiness, if any.
    ///
    /// This is typically provided when the status is "Sakit" or "Izin".
    @JsonKey(name: "alasan") String? alasan,

    /// The school unit or branch code where the student is registered.
    @JsonKey(name: "unit") required String unit,

    /// The timestamp when the attendance record was first created in the database.
    @JsonKey(name: "created_at") required DateTime createdAt,

    /// The timestamp of the last update to the record.
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _DailyAttendance;

  /// Creates a [DailyAttendance] instance from a JSON map.
  ///
  /// This factory is used for deserializing the JSON response from the API
  /// into a `DailyAttendance` object.
  factory DailyAttendance.fromJson(Map<String, dynamic> json) =>
      _$DailyAttendanceFromJson(json);
}
