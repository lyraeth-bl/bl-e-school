import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_daily_attendance_cubit.freezed.dart';
part 'post_daily_attendance_state.dart';

/// {@template post_daily_attendance_cubit}
/// A [Cubit] that manages the state for posting a student's daily attendance.
///
/// This cubit is responsible for a single action: creating the initial attendance
/// record for a student at the beginning of the day. It orchestrates the
/// interaction with the [AttendanceRepository] and reflects the status of this
/// operation through its [PostDailyAttendanceState].
/// {@endtemplate}
class PostDailyAttendanceCubit extends Cubit<PostDailyAttendanceState> {
  /// The repository that provides methods for attendance-related API calls.
  final AttendanceRepository _attendanceRepository;

  /// {@macro post_daily_attendance_cubit}
  PostDailyAttendanceCubit(this._attendanceRepository)
    : super(const _Initial());

  /// Submits a new daily attendance record for a student.
  ///
  /// This function initiates the process of creating a new attendance entry for the
  /// specified student (`nis`) and school `unit`.
  ///
  /// It follows a clear state transition:
  /// 1. Emits [PostDailyAttendanceState.loading] to indicate the operation has started.
  /// 2. Calls the repository to make the API request.
  /// 3. On success, it extracts the new [DailyAttendance] data from the response
  ///    and emits [PostDailyAttendanceState.success] with this data.
  /// 4. If any error occurs during the API call (e.g., network issues, server errors),
  ///    it catches the exception and emits [PostDailyAttendanceState.failure] with
  ///    a descriptive error message.
  Future<void> postDailyAttendanceUser({
    required String nis,
    required String unit,
  }) async {
    // Indicate that the attendance posting process is starting.
    emit(const _Loading());

    try {
      // Attempt to post the attendance via the repository.
      final result = await _attendanceRepository.postDailyAttendanceUser(
        nis: nis,
        unit: unit,
      );

      // Extract the returned attendance data on success.
      final dailyAttendanceData =
          result['dailyAttendanceData'] as DailyAttendance;

      // Announce the successful creation of the attendance record.
      emit(_Success(dailyAttendance: dailyAttendanceData));
    } catch (e) {
      // Announce that an error occurred during the process.
      emit(_Failure(e.toString()));
    }
  }
}
