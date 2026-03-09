part of 'time_table_bloc.dart';

@freezed
abstract class TimeTableState with _$TimeTableState {
  const factory TimeTableState.initial() = _Initial;

  const factory TimeTableState.loading() = _Loading;

  const factory TimeTableState.success({
    required List<TimeTable> timeTableList,
  }) = _Success;

  const factory TimeTableState.failure(Failure failure) = _Failure;
}
