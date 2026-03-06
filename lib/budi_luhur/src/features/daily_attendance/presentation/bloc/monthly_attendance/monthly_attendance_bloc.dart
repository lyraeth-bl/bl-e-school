import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_attendance_bloc.freezed.dart';
part 'monthly_attendance_event.dart';
part 'monthly_attendance_state.dart';

class MonthlyAttendanceBloc
    extends Bloc<MonthlyAttendanceEvent, MonthlyAttendanceState> {
  final DailyAttendanceRepository _dailyAttendanceRepository;

  MonthlyAttendanceBloc(this._dailyAttendanceRepository)
    : super(const MonthlyAttendanceState.initial()) {
    on<_Fetch>(_onFetch);
  }

  Future<void> _onFetch(
    _Fetch event,
    Emitter<MonthlyAttendanceState> emit,
  ) async {
    emit(const MonthlyAttendanceState.loading());

    final result = await _dailyAttendanceRepository.fetchMonthlyAttendance(
      year: event.year,
      month: event.month,
      forceRefresh: event.forceRefresh,
    );

    result.match(
      (failure) => emit(MonthlyAttendanceState.failure(failure)),
      (data) => emit(
        MonthlyAttendanceState.success(
          listDailyAttendance: data.list,
          year: event.year,
          month: event.month,
          lastUpdated: data.lastUpdated,
        ),
      ),
    );
  }
}
