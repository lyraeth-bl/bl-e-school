part of 'today_attendance_bloc.dart';

@freezed
abstract class TodayAttendanceState with _$TodayAttendanceState {
  const factory TodayAttendanceState.initial() = _Initial;

  const factory TodayAttendanceState.loading() = _Loading;

  const factory TodayAttendanceState.success({
    required DailyAttendance dailyAttendance,
  }) = _Success;

  const factory TodayAttendanceState.noAttendanceToday() = _NoAttendanceToday;

  const factory TodayAttendanceState.failure(Failure failure) = _Failure;
}
