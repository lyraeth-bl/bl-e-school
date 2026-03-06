part of 'today_attendance_bloc.dart';

@freezed
abstract class TodayAttendanceEvent with _$TodayAttendanceEvent {
  const factory TodayAttendanceEvent.started({
    @Default(false) bool forceRefresh,
  }) = _Started;
}
