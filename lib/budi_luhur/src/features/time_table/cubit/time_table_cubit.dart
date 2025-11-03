import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'time_table_cubit.freezed.dart';
part 'time_table_state.dart';

/// {@template time_table_cubit}
/// A [HydratedCubit] for managing the state of the school timetable.
///
/// This cubit is responsible for fetching the timetable data from the
/// [TimeTableRepository], handling pagination (fetching more data), and
/// persisting its state to local storage. This ensures the timetable is
/// available offline and across app restarts.
/// {@endtemplate}
class TimeTableCubit extends HydratedCubit<TimeTableState> {
  final TimeTableRepository _timeTableRepository;

  /// {@macro time_table_cubit}
  TimeTableCubit(this._timeTableRepository) : super(const _Initial());

  /// Fetches the initial list of timetable entries for a given page.
  ///
  /// This method is typically called to load the first page of data or to
  /// perform a full refresh. It follows a clear state transition:
  ///
  /// 1. Emits [TimeTableState.loading] to signal the start of the data fetch.
  /// 2. Calls the [TimeTableRepository] to get the data from the API.
  /// 3. On success, it emits [TimeTableState.success] with the fetched data.
  /// 4. If an error occurs, it emits [TimeTableState.failure] with an error message.
  ///
  /// - [page]: The page number to fetch. Defaults to 1.
  Future<void> fetchTimeTable({int? page = 1}) async {
    emit(const TimeTableState.loading());

    try {
      final result = await _timeTableRepository.fetchTimeTable(page: page);

      final List<TimeTable>? timeTableList = result.listTimeTable;

      emit(
        TimeTableState.success(
          timeTableResponse: result,
          timeTableList: timeTableList ?? [],
        ),
      );
    } catch (e) {
      emit(TimeTableState.failure(e.toString()));
    }
  }

  /// A convenience getter to determine if there are more pages to load.
  ///
  /// Returns `true` if the current page is less than the total number of pages
  /// available from the API. Returns `false` otherwise, or if the total pages
  /// count is not available.
  bool get hasMore => state.maybeWhen(
        success: (timeTableResponse, timeTableList, loadMore) {
          final totalPages = timeTableResponse.totalPages;

          if (totalPages == null) return false;

          return timeTableResponse.page < totalPages;
        },
        orElse: () => false,
      );

  /// Fetches the next page of timetable data and appends it to the current list.
  ///
  /// This method handles the logic for pagination. It ensures that a "load more"
  /// action is only triggered when appropriate (i.e., not already loading, and
  /// more pages are available).
  ///
  /// The process is as follows:
  /// 1. Checks if the current state is `success` and not already loading more.
  /// 2. Verifies that more pages are available using the [hasMore] getter.
  /// 3. Emits a new `success` state with `loadMore: true` to let the UI
  ///    show a loading indicator at the bottom of the list.
  /// 4. Fetches the data for the next page.
  /// 5. Combines the existing list with the new items.
  /// 6. Emits a final `success` state with the updated list and `loadMore: false`.
  /// 7. If an error occurs during the fetch, it reverts to the previous state
  ///    (before `loadMore` was set to `true`) and also emits a `failure` state.
  Future<void> fetchMoreTimeTable() async {
    final current = state.maybeWhen(
      success: (timeTableResponse, timeTableList, loadMore) =>
          (timeTableResponse, timeTableList, loadMore),
      orElse: () => null,
    );

    // Only proceed if the current state is success.
    if (current == null) return;

    final timeTableResponse = current.$1;
    final timeTableList = List<TimeTable>.from(current.$2);
    final currentlyLoadingMore = current.$3;

    // Prevent concurrent "load more" requests.
    if (currentlyLoadingMore) return;

    // Exit if there are no more pages to fetch.
    if (!hasMore) return;

    // Set `loadMore` to true so the UI can show a bottom loader.
    emit(
      TimeTableState.success(
        timeTableResponse: timeTableResponse,
        timeTableList: timeTableList,
        loadMore: true,
      ),
    );

    try {
      final nextPage = timeTableResponse.page + 1;
      final result = await _timeTableRepository.fetchTimeTable(page: nextPage);

      final newItems = result.listTimeTable ?? [];

      // Append the new items to the existing list.
      final combined = <TimeTable>[...timeTableList, ...newItems];

      // Emit success with the updated response and combined list.
      emit(
        TimeTableState.success(
          timeTableResponse: result,
          timeTableList: combined,
          loadMore: false,
        ),
      );
    } catch (e) {
      // If an error occurs while fetching more, fallback to the previous data
      // and turn off the loading indicator.
      emit(
        TimeTableState.success(
          timeTableResponse: timeTableResponse,
          timeTableList: timeTableList,
          loadMore: false,
        ),
      );
      // Optionally, emit a failure state to notify the user globally.
      emit(TimeTableState.failure(e.toString()));
    }
  }

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
            timeTableResponse: TimeTableResponse.fromJson(
              json['timeTableResponse'],
            ),
            timeTableList: (json['timeTableList'] as List<dynamic>)
                .map((e) => TimeTable.fromJson(e as Map<String, dynamic>))
                .toList(),
            loadMore: json['loadMore'] as bool? ?? false,
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
      success: (timeTableResponse, timeTableList, loadMore) => {
        'type': 'success',
        'timeTableResponse': timeTableResponse.toJson(),
        'timeTableList': timeTableList.map((e) => e.toJson()).toList(),
        'loadMore': loadMore,
      },
    );
  }
}
