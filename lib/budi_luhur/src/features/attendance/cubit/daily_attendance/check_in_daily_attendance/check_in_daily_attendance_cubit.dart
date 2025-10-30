import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in_daily_attendance_cubit.freezed.dart';
part 'check_in_daily_attendance_state.dart';

/// A Cubit that manages the state for the daily check-in feature.
///
/// This cubit is responsible for handling the logic of a user checking in,
/// interacting with the [AttendanceRepository] to update the attendance status.
class CheckInDailyAttendanceCubit extends Cubit<CheckInDailyAttendanceState> {
  final AttendanceRepository _attendanceRepository;

  /// Creates an instance of [CheckInDailyAttendanceCubit].
  ///
  /// Requires an [AttendanceRepository] to be provided, which is used to make
  /// the actual API calls for checking in.
  CheckInDailyAttendanceCubit(this._attendanceRepository) : super(const _Initial());

  /// Performs the check-in action for a user.
  ///
  /// This method will emit a [CheckInDailyAttendanceState.loading] state, then
  /// attempt to check in the user using the provided [id] and [checkIn] time.
  ///
  /// On a successful check-in, it will emit a
  /// [CheckInDailyAttendanceState.success] state with the updated attendance data.
  ///
  /// If an error occurs during the process, it will emit a
  /// [CheckInDailyAttendanceState.failure] state with the corresponding error
  /// message.
  Future<void> checkIn({required int id, required DateTime checkIn}) async {
    emit(const _Loading());

    try {
      final result = await _attendanceRepository
          .putDailyAttendanceUserForCheckIn(id: id, checkIn: checkIn);

      final dailyAttendanceData =
          result['dailyAttendanceData'] as DailyAttendance;

      emit(_Success(dailyAttendance: dailyAttendanceData));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
