part of 'fetch_daily_attendance_cubit.dart';

/// Represents the various states of fetching daily attendance data.
@freezed
abstract class FetchDailyAttendanceState with _$FetchDailyAttendanceState {
  /// The initial state before any data has been fetched.
  const factory FetchDailyAttendanceState.initial() = _Initial;

  /// The state indicating that the data is currently being loaded.
  const factory FetchDailyAttendanceState.loading() = _Loading;

  /// The state indicating that the data has been successfully fetched.
  ///
  /// This state holds the list of attendance records for a specific month and year.
  const factory FetchDailyAttendanceState.success({
    /// A list of [DailyAttendance] records for the fetched period.
    required List<DailyAttendance> dailyAttendanceList,

    /// The year for which the attendance data was fetched.
    required int year,

    /// The month for which the attendance data was fetched.
    required int month,

    /// The timestamp of the last successful data fetch.
    required DateTime lastUpdated,
  }) = _Success;

  /// The state indicating that an error occurred while fetching the data.
  ///
  /// Contains the [errorMessage] that describes the failure.
  const factory FetchDailyAttendanceState.failure(String errorMessage) =
      _Failure;
}
