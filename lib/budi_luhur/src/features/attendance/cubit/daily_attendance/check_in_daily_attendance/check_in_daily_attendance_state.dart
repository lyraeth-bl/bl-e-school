part of 'check_in_daily_attendance_cubit.dart';

/// Represents the various states of the daily attendance check-in process.
@freezed
abstract class CheckInDailyAttendanceState with _$CheckInDailyAttendanceState {
  /// The initial state before any check-in action has been taken.
  const factory CheckInDailyAttendanceState.initial() = _Initial;

  /// The state indicating that a check-in operation is currently in progress.
  const factory CheckInDailyAttendanceState.loading() = _Loading;

  /// The state indicating that the check-in operation was successful.
  ///
  /// Contains the updated [dailyAttendance] data.
  const factory CheckInDailyAttendanceState.success({
    required DailyAttendance dailyAttendance,
  }) = _Success;

  /// The state indicating that the check-in operation has failed.
  ///
  /// Contains the [errorMessage] detailing the cause of the failure.
  const factory CheckInDailyAttendanceState.failure(String errorMessage) =
      _Failure;
}
