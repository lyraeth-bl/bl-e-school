part of 'time_table_cubit.dart';

/// Represents the various states of the timetable feature.
///
/// This sealed class defines the possible states for the [TimeTableCubit],
/// including initial, loading, success, and failure states.
@freezed
abstract class TimeTableState with _$TimeTableState {
  /// The initial state, representing the time before any data has been fetched.
  const factory TimeTableState.initial() = _Initial;

  /// The loading state, indicating that timetable data is currently being fetched
  /// from the repository.
  const factory TimeTableState.loading() = _Loading;

  /// The success state, indicating that the timetable data has been successfully
  /// loaded.
  ///
  /// This state contains the response from the API and the list of timetable entries.
  const factory TimeTableState.success({
    /// The full response from the timetable API, including pagination details.
    required TimeTableResponse timeTableResponse,

    /// The list of [TimeTable] entries to be displayed.
    required List<TimeTable> timeTableList,

    /// A flag to indicate whether a "load more" operation is in progress.
    ///
    /// This is typically used to show a loading indicator at the bottom of a list
    /// while fetching the next page of data.
    @Default(false) bool loadMore,
  }) = _Success;

  /// The failure state, indicating that an error occurred while fetching
  /// the timetable data.
  ///
  /// - [errorMessage]: A message describing the error that occurred.
  const factory TimeTableState.failure(String errorMessage) = _Failure;
}
