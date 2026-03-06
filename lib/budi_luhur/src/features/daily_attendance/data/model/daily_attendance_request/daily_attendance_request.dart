import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_attendance_request.freezed.dart';
part 'daily_attendance_request.g.dart';

@freezed
abstract class DailyAttendanceRequest with _$DailyAttendanceRequest {
  const factory DailyAttendanceRequest({
    required int year,
    required int month,
  }) = _DailyAttendanceRequest;

  factory DailyAttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$DailyAttendanceRequestFromJson(json);
}
