part of 'check_out_daily_attendance_cubit.dart';

/// Represents the various states of the daily attendance check-out process.
@freezed
abstract class CheckOutDailyAttendanceState with _$CheckOutDailyAttendanceState {
  /// The initial state before any check-out action has been taken.
  const factory CheckOutDailyAttendanceState.initial() = _Initial;

  /// The state indicating that a check-out operation is currently in progress.
  const factory CheckOutDailyAttendanceState.loading() = _Loading;

  /// The state indicating that the check-out operation was successful.
  ///
  /// Contains the updated [dailyAttendance] data.
  const factory CheckOutDailyAttendanceState.success({
    required DailyAttendance dailyAttendance,
  }) = _Success;

  /// The state indicating that the check-out operation has failed.
  ///
  /// Contains the [errorMessage] detailing the cause of the failure.
  const factory CheckOutDailyAttendanceState.failure(String errorMessage) =
      _Failure;
}
