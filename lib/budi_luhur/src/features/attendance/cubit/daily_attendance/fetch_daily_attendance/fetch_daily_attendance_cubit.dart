import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'fetch_daily_attendance_cubit.freezed.dart';
part 'fetch_daily_attendance_state.dart';

/// {@template fetch_daily_attendance_cubit}
/// A [HydratedCubit] responsible for fetching and caching the daily attendance
/// history for a specific user over a given month and year.
///
/// This cubit interacts with the [AttendanceRepository] to retrieve attendance
/// data. By extending [HydratedCubit], it automatically persists its state,
/// allowing the attendance history to be available offline and reducing
/// redundant API calls.
/// {@endtemplate}
class FetchDailyAttendanceCubit
    extends HydratedCubit<FetchDailyAttendanceState> {
  final AttendanceRepository _attendanceRepository;

  /// {@macro fetch_daily_attendance_cubit}
  ///
  /// Creates a new instance of [FetchDailyAttendanceCubit].
  /// Requires an [AttendanceRepository] to fetch data from the underlying
  /// data source.
  FetchDailyAttendanceCubit(this._attendanceRepository)
    : super(const _Initial());

  /// Fetches the custom daily attendance for a specific user, month, and year.
  ///
  /// This method orchestrates the data fetching process. It includes a simple
  /// caching mechanism to avoid redundant network requests if the data for the
  /// requested month and year is already in the state.
  ///
  /// - [nis]: The student's unique identification number.
  /// - [year]: The year for which to fetch the attendance data.
  /// - [month]: The month for which to fetch the attendance data.
  /// - [unit]: The school unit or branch code.
  /// - [forceRefresh]: If `true`, the cubit will always fetch new data from the
  ///   repository, ignoring any cached state. Defaults to `false`.
  ///
  /// State Transitions:
  /// 1. Emits [FetchDailyAttendanceState.loading] to indicate the start of the fetch.
  /// 2. Calls the repository to get the attendance data.
  /// 3. On success, emits [FetchDailyAttendanceState.success] with the fetched list,
  ///    year, month, and the current timestamp as `lastUpdated`.
  /// 4. On failure, catches the exception and emits [FetchDailyAttendanceState.failure]
  ///    with an error message.
  Future<void> fetchCustomDailyAttendanceUser({
    required String nis,
    required int year,
    required int month,
    required String unit,
    bool forceRefresh = false,
  }) async {
    final current = state;
    // Avoid fetching if the data for the same month and year is already present,
    // unless a force refresh is requested.
    if (!forceRefresh &&
        current is _Success &&
        current.year == year &&
        current.month == month) {
      return;
    }

    emit(const _Loading());

    try {
      final result = await _attendanceRepository.getCustomDailyAttendanceUser(
        nis: nis,
        year: year,
        month: month,
        unit: unit,
      );

      final dailyAttendanceList =
          result['customDailyAttendanceList'] as List<DailyAttendance>;

      final now = DateTime.now();

      emit(
        _Success(
          dailyAttendanceList: dailyAttendanceList,
          year: year,
          month: month,
          lastUpdated: now,
        ),
      );
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }

  /// Deserializes the cubit's state from a JSON map for state persistence.
  ///
  /// This method is part of the [HydratedCubit] API and is called automatically
  /// when the app starts to restore the previous state.
  @override
  FetchDailyAttendanceState? fromJson(Map<String, dynamic> json) {
    try {
      final stateType = json['state'] as String?;
      if (stateType == null) return const _Initial();

      switch (stateType) {
        case 'success':
          final year = json['year'] as int;
          final month = json['month'] as int;
          final lastUpdatedMillis = json['lastUpdated'] as int?;
          final lastUpdated = lastUpdatedMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(lastUpdatedMillis)
              : DateTime.now();

          final listJson = (json['list'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
          final dailyList = listJson
              .map((m) => DailyAttendance.fromJson(m))
              .toList();
          return _Success(
            dailyAttendanceList: dailyList,
            year: year,
            month: month,
            lastUpdated: lastUpdated,
          );

        case 'failure':
          final message = json['message'] as String? ?? 'Unknown';
          return _Failure(message);

        case 'loading':
          return const _Loading();

        case 'initial':
        default:
          return const _Initial();
      }
    } catch (_) {
      // If parsing fails for any reason, discard the cached state
      // and start fresh to avoid corruption.
      return const _Initial();
    }
  }

  /// Serializes the cubit's current state into a JSON map for persistence.
  ///
  /// This method is part of the [HydratedCubit] API and is called automatically
  /// whenever the state changes.
  @override
  Map<String, dynamic>? toJson(FetchDailyAttendanceState state) {
    return state.when<Map<String, dynamic>?>(
      initial: () => {'state': 'initial'},
      loading: () => {'state': 'loading'},
      success: (dailyAttendanceList, year, month, lastUpdated) {
        // Convert the list of DailyAttendance objects to a list of JSON maps.
        final listJson = dailyAttendanceList.map((d) => d.toJson()).toList();
        return {
          'state': 'success',
          'year': year,
          'month': month,
          // Store the timestamp as milliseconds since epoch for simple serialization.
          'lastUpdated': lastUpdated.millisecondsSinceEpoch,
          'list': listJson,
        };
      },
      failure: (message) => {'state': 'failure', 'message': message},
    );
  }
}
