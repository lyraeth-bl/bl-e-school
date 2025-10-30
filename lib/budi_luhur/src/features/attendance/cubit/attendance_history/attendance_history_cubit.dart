import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_history_cubit.freezed.dart';
part 'attendance_history_state.dart';

/// Cubit for managing attendance history.
class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final AttendanceRepository _attendanceRepository;

  /// Creates an instance of [AttendanceHistoryCubit].
  AttendanceHistoryCubit(this._attendanceRepository) : super(const _Initial());

  /// Fetches attendance history with a filter.
  ///
  /// This method fetches the first page of attendance history with the given
  /// [nis], [page], [year], [month], and [unit].
  Future<void> fetchAttendanceHistoryWithFilter({
    required String nis,
    int page = 1,
    int? year,
    int? month,
    String? unit,
  }) async {
    emit(_Loading());

    final result = await _attendanceRepository.getCustomAttendanceUser(
      nis: nis,
      page: page,
      year: year,
      month: month,
      unit: unit,
    );

    final attendanceHistoryList = result.listAttendance;

    emit(
      _Success(
        attendanceResponse: result,
        attendanceList: attendanceHistoryList,
      ),
    );
  }

  /// Fetches more attendance history.
  ///
  /// This method is used for pagination. It fetches the next page of attendance
  /// history and appends it to the current list.
  Future<void> fetchMoreAttendanceHistory({
    required String nis,
    int? year,
    int? month,
    String? unit,
  }) async {
    final s = state;

    if (s is _Success && !s.loadMore) {
      final lastResponse = s.attendanceResponse;
      final currentPage = lastResponse.currentPage ?? 1;
      final lastPage = lastResponse.lastPage ?? currentPage;

      if (currentPage >= lastPage) {
        return;
      }

      emit(
        _Success(
          attendanceResponse: lastResponse,
          attendanceList: s._attendanceList,
          loadMore: true,
        ),
      );

      try {
        final nextPage = currentPage + 1;

        final result = await _attendanceRepository.getCustomAttendanceUser(
          nis: nis,
          page: nextPage,
          month: month,
          year: year,
          unit: unit,
        );

        final anotherAttendanceHistory = result.listAttendance;
        final mergedAttendanceHistory = <AttendanceHistory>[
          ...s._attendanceList,
          ...anotherAttendanceHistory,
        ];

        final newResponse = result.copyWith(
          listAttendance: mergedAttendanceHistory,
        );

        if (!isClosed) {
          emit(
            _Success(
              attendanceResponse: newResponse,
              attendanceList: mergedAttendanceHistory,
              loadMore: false,
            ),
          );
        }
      } catch (e) {
        if (!isClosed) emit(_Failure(e.toString()));
      }
    }
  }

  /// Returns true if there are more pages to load.
  bool get loadMore => state.maybeWhen(
    success: (attendanceResponse, attendanceList, loadMore) {
      final currentPage = attendanceResponse.currentPage ?? 1;
      final lastPage = attendanceResponse.lastPage ?? currentPage;

      return currentPage < lastPage;
    },
    orElse: () => false,
  );
}
