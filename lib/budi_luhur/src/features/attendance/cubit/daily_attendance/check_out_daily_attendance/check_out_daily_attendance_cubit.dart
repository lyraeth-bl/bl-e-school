import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_out_daily_attendance_cubit.freezed.dart';
part 'check_out_daily_attendance_state.dart';

/// A cubit that manages the state for the daily check-out feature.
///
/// This cubit is responsible for handling the logic of a user checking out,
/// interacting with the [AttendanceRepository] to update the attendance status.
class CheckOutDailyAttendanceCubit extends Cubit<CheckOutDailyAttendanceState> {
  final AttendanceRepository _attendanceRepository;

  /// Creates an instance of [CheckOutDailyAttendanceCubit].
  ///
  /// Requires an [AttendanceRepository] to be provided, which is used to make
  /// the actual API calls for checking out.
  CheckOutDailyAttendanceCubit(this._attendanceRepository) : super(const _Initial());

  /// Performs the check-out action for a user.
  ///
  /// This method will emit a [CheckOutDailyAttendanceState.loading] state, then
  /// attempt to check out the user using the provided [id] and [checkOut] time.
  ///
  /// On a successful check-out, it will emit a
  /// [CheckOutDailyAttendanceState.success] state with the updated attendance data.
  ///
  /// If an error occurs during the process, it will emit a
  /// [CheckOutDailyAttendanceState.failure] state with the corresponding error
  /// message.
  Future<void> checkOut({required int id, required DateTime checkOut}) async {
    emit(const _Loading());

    try {
      final result = await _attendanceRepository
          .putDailyAttendanceUserForCheckOut(id: id, checkOut: checkOut);

      final dailyAttendanceData =
          result['dailyAttendanceData'] as DailyAttendance;

      emit(_Success(dailyAttendance: dailyAttendanceData));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
