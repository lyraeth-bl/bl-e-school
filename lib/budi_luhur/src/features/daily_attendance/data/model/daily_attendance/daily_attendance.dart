import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_attendance.freezed.dart';
part 'daily_attendance.g.dart';

@freezed
abstract class DailyAttendance with _$DailyAttendance {
  const factory DailyAttendance({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "nis") required String nis,
    @JsonKey(name: "tajaran") required String schoolSession,
    @JsonKey(name: "semester") required String semester,
    @JsonKey(name: "tanggal") required DateTime date,
    @JsonKey(name: "checkIn") DateTime? checkInClock,
    @JsonKey(name: "checkOut") DateTime? checkOutClock,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "alasan") String? reason,
    @JsonKey(name: "unit") required String unit,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _DailyAttendance;

  factory DailyAttendance.fromJson(Map<String, dynamic> json) =>
      _$DailyAttendanceFromJson(json);
}
