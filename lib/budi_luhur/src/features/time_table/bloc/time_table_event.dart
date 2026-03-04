part of 'time_table_bloc.dart';

@freezed
abstract class TimeTableEvent with _$TimeTableEvent {
  const factory TimeTableEvent.started() = _Started;

  const factory TimeTableEvent.timeTableRequested({
    @Default(false) bool forceRefresh,
    required String kelas,
  }) = _TimeTableRequested;
}
