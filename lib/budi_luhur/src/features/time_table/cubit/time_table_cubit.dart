import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'time_table_cubit.freezed.dart';
part 'time_table_state.dart';

/// {@template time_table_cubit}
/// A [HydratedCubit] for managing the state of the school timetable.
///
/// This cubit is responsible for fetching the timetable data from the
/// [TimeTableRepository], persisting its state to local storage.
/// This ensures the timetable is available offline and across app restarts.
/// {@endtemplate}
class TimeTableCubit extends HydratedCubit<TimeTableState> {
  final TimeTableRepository _timeTableRepository;

  /// {@macro time_table_cubit}
  TimeTableCubit(this._timeTableRepository) : super(const _Initial());

  /// Fetches the initial list of timetable entries for a given class.
  ///
  /// This method is typically called to load the first page of data or to
  /// perform a full refresh. It follows a clear state transition:
  ///
  /// 1. Emits [TimeTableState.loading] to signal the start of the data fetch.
  /// 2. Calls the [TimeTableRepository] to get the data from the API.
  /// 3. On success, it emits [TimeTableState.success] with the fetched data.
  /// 4. If an error occurs, it emits [TimeTableState.failure] with an error message.
  ///
  /// - [kelas]: The student class to fetch.
  Future<void> fetchTimeTable({
    required String kelas,
    bool forceRefresh = false,
  }) async {
    final currentState = state;

    if (!forceRefresh && currentState is _Success) {
      return;
    }

    emit(const TimeTableState.loading());

    try {
      final result = await _timeTableRepository.fetchTimeTable(kelas: kelas);

      final List<TimeTable>? timeTableList = result.listTimeTable;

      emit(TimeTableState.success(timeTableList: timeTableList ?? []));
    } catch (e) {
      emit(TimeTableState.failure(e.toString()));
    }
  }

  List<TimeTable> get getTimeTable => state.maybeWhen(
    success: (timeTableList) => timeTableList,
    orElse: () => [],
  );

  /// Deserializes the cubit's state from a JSON map.
  ///
  /// This is part of the [HydratedCubit] functionality for state persistence.
  @override
  TimeTableState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;

      switch (type) {
        case 'success':
          return TimeTableState.success(
            timeTableList: (json['timeTableList'] as List<dynamic>)
                .map((e) => TimeTable.fromJson(e as Map<String, dynamic>))
                .toList(),
          );

        case 'failure':
          return TimeTableState.failure(json['errorMessage'] as String);

        case 'loading':
          return const TimeTableState.loading();

        case 'initial':
        default:
          return const TimeTableState.initial();
      }
    } catch (e) {
      return const TimeTableState.initial();
    }
  }

  /// Serializes the cubit's state into a JSON map.
  ///
  /// This is part of the [HydratedCubit] functionality for state persistence.
  @override
  Map<String, dynamic>? toJson(TimeTableState state) {
    return state.whenOrNull(
      initial: () => {'type': 'initial'},
      loading: () => {'type': 'loading'},
      failure: (errorMessage) => {
        'type': 'failure',
        'errorMessage': errorMessage,
      },
      success: (timeTableList) => {
        'type': 'success',
        'timeTableList': timeTableList.map((e) => e.toJson()).toList(),
      },
    );
  }
}
