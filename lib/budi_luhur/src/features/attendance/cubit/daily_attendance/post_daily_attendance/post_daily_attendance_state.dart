part of 'post_daily_attendance_cubit.dart';

/// Represents the various states of the daily attendance posting process.
@freezed
abstract class PostDailyAttendanceState with _$PostDailyAttendanceState {
  /// The initial state before any posting action has been taken.
  const factory PostDailyAttendanceState.initial() = _Initial;

  /// The state indicating that a post operation is currently in progress.
  const factory PostDailyAttendanceState.loading() = _Loading;

  /// The state indicating that the post operation was successful.
  ///
  /// Contains the newly created [dailyAttendance] data.
  const factory PostDailyAttendanceState.success({
    required DailyAttendance dailyAttendance,
  }) = _Success;

  /// The state indicating that the post operation has failed.
  ///
  /// Contains the [errorMessage] detailing the cause of the failure.
  const factory PostDailyAttendanceState.failure(String errorMessage) =
      _Failure;
}
