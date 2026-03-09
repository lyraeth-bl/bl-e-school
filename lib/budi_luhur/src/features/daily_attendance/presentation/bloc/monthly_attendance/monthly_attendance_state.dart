part of 'monthly_attendance_bloc.dart';

@freezed
class MonthlyAttendanceState with _$MonthlyAttendanceState {
  const factory MonthlyAttendanceState.initial() = _Initial;

  const factory MonthlyAttendanceState.loading() = _Loading;

  const factory MonthlyAttendanceState.success({
    required List<DailyAttendance> listDailyAttendance,
    required int year,
    required int month,
    required DateTime lastUpdated,
  }) = _Success;

  const factory MonthlyAttendanceState.failure(Failure failure) = _Failure;
}
