import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure/failure.dart';
import '../../data/model/time_table/time_table.dart';
import '../../repository/time_table_repository.dart';

part 'time_table_bloc.freezed.dart';
part 'time_table_event.dart';
part 'time_table_state.dart';

class TimeTableBloc extends Bloc<TimeTableEvent, TimeTableState> {
  final TimeTableRepository _timeTableRepository;

  TimeTableBloc(this._timeTableRepository)
    : super(const TimeTableState.initial()) {
    on<_TimeTableRequested>(_onTimeTableRequested);
  }

  Future<void> _onTimeTableRequested(
    _TimeTableRequested event,
    Emitter<TimeTableState> emit,
  ) async {
    if (!event.forceRefresh && state is _Success) return;

    final storedTimeTableData = _timeTableRepository.getStoredTimeTable();

    if (!event.forceRefresh && storedTimeTableData != null) {
      emit(TimeTableState.success(timeTableList: storedTimeTableData));
      debugPrint("TimeTableState.success with local data");
      return;
    }

    emit(const TimeTableState.loading());

    final result = await _timeTableRepository.fetchTimeTable(
      kelas: event.kelas,
    );

    final failure = result.match((f) => f, (_) => null);
    final timeTableResponse = result.match((_) => null, (r) => r);

    if (failure != null) {
      emit(TimeTableState.failure(failure));
      return;
    }

    if (timeTableResponse != null) {
      await _timeTableRepository.storeTimeTable(
        timeTableResponse.listTimeTable,
      );
      debugPrint("_timeTableRepository.storeTimeTable() success");
      emit(
        TimeTableState.success(timeTableList: timeTableResponse.listTimeTable),
      );
    }
  }
}
