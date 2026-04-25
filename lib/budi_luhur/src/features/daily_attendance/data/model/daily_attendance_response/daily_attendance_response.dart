import 'package:freezed_annotation/freezed_annotation.dart';

import '../daily_attendance/daily_attendance.dart';

part 'daily_attendance_response.freezed.dart';
part 'daily_attendance_response.g.dart';

@freezed
abstract class DailyAttendanceResponse with _$DailyAttendanceResponse {
  const factory DailyAttendanceResponse({
    required bool error,
    required String message,
    @JsonKey(name: "data") List<DailyAttendance>? listDailyAttendance,
    @JsonKey(name: "code") required int codeResponse,
  }) = _DailyAttendanceResponse;

  factory DailyAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyAttendanceResponseFromJson(json);
}
