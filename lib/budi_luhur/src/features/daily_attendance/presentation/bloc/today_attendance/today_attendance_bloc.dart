import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failure/failure.dart';
import '../../../data/model/daily_attendance/daily_attendance.dart';
import '../../../repository/daily_attendance_repository.dart';

part 'today_attendance_bloc.freezed.dart';
part 'today_attendance_event.dart';
part 'today_attendance_state.dart';

class TodayAttendanceBloc
    extends Bloc<TodayAttendanceEvent, TodayAttendanceState> {
  final DailyAttendanceRepository _dailyAttendanceRepository;

  TodayAttendanceBloc(this._dailyAttendanceRepository)
    : super(const TodayAttendanceState.initial()) {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<TodayAttendanceState> emit,
  ) async {
    emit(const TodayAttendanceState.loading());

    final result = await _dailyAttendanceRepository.fetchTodayAttendance(
      forceRefresh: event.forceRefresh,
    );

    result.match(
      (failure) {
        if (failure.errorMessage == 'noAttendanceToday') {
          emit(const TodayAttendanceState.noAttendanceToday());
        } else {
          emit(TodayAttendanceState.failure(failure));
        }
      },
      (attendance) =>
          emit(TodayAttendanceState.success(dailyAttendance: attendance)),
    );
  }
}
