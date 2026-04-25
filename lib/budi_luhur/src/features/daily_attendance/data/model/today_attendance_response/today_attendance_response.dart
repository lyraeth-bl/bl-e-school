import 'package:freezed_annotation/freezed_annotation.dart';

import '../daily_attendance/daily_attendance.dart';

part 'today_attendance_response.freezed.dart';
part 'today_attendance_response.g.dart';

@freezed
abstract class TodayAttendanceResponse with _$TodayAttendanceResponse {
  const factory TodayAttendanceResponse({
    required bool error,
    required String message,
    @JsonKey(name: "data") DailyAttendance? dailyAttendance,
    required int code,
  }) = _TodayAttendanceResponse;

  factory TodayAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$TodayAttendanceResponseFromJson(json);
}
