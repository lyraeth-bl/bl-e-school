part of 'monthly_attendance_bloc.dart';

@freezed
abstract class MonthlyAttendanceEvent with _$MonthlyAttendanceEvent {
  const factory MonthlyAttendanceEvent.fetch({
    required int year,
    required int month,
    @Default(false) bool forceRefresh,
  }) = _Fetch;
}
