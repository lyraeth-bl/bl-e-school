import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_daily_attendance_cubit.freezed.dart';
part 'fetch_daily_attendance_state.dart';

/// A cubit responsible for fetching daily attendance data.
class FetchDailyAttendanceCubit extends Cubit<FetchDailyAttendanceState> {
  final AttendanceRepository _attendanceRepository;

  /// Creates a new instance of [FetchDailyAttendanceCubit].
  ///
  /// Requires an [AttendanceRepository] to fetch data.
  FetchDailyAttendanceCubit(this._attendanceRepository)
    : super(const _Initial());

  /// Fetches the custom daily attendance for a specific user.
  ///
  /// This method emits a [_Loading] state, then fetches the daily attendance
  /// data using the provided [nis], [year], [month], and [unit].
  /// On success, it emits a [_Success] state with the list of
  /// [DailyAttendance]. On failure, it emits a [_Failure] state with an
  /// error message.
  Future<void> fetchCustomDailyAttendanceUser({
    required String nis,
    required int year,
    required int month,
    required String unit,
  }) async {
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

      if (dailyAttendanceList.isEmpty) {
        emit(const _Success(dailyAttendanceList: []));
      } else {
        emit(_Success(dailyAttendanceList: dailyAttendanceList));
      }
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
