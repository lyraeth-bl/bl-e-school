part of 'attendance_history_cubit.dart';

/// Represents the state of the attendance history feature.
@freezed
abstract class AttendanceHistoryState with _$AttendanceHistoryState {
  /// The initial state.
  const factory AttendanceHistoryState.initial() = _Initial;

  /// The loading state, indicating that data is being fetched.
  const factory AttendanceHistoryState.loading() = _Loading;

  /// The success state, indicating that data has been successfully fetched.
  const factory AttendanceHistoryState.success({
    /// The response from the API.
    required AttendanceHistoryResponse attendanceResponse,

    /// The list of attendance history items.
    required List<AttendanceHistory> attendanceList,

    /// A flag to indicate whether more data is being loaded for pagination.
    @Default(false) bool loadMore,
  }) = _Success;

  /// The failure state, indicating that an error occurred while fetching data.
  const factory AttendanceHistoryState.failure(
    /// The error message.
    String errorMessage,
  ) = _Failure;
}
