import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'academic_calendar_cubit.freezed.dart';
part 'academic_calendar_state.dart';

/// Manages the state of the academic calendar, fetching and caching data.
///
/// This Cubit extends [HydratedCubit] to persist the academic calendar state
/// across app restarts, reducing redundant network requests.
class AcademicCalendarCubit extends HydratedCubit<AcademicCalendarState> {
  final AcademicCalendarRepository _academicCalendarRepository;

  /// Creates an instance of [AcademicCalendarCubit].
  ///
  /// Requires an [AcademicCalendarRepository] to fetch data.
  AcademicCalendarCubit(this._academicCalendarRepository) : super(_Initial());

  /// Fetches the academic calendar for a specific month, year, and unit.
  ///
  /// Emits a [_Loading] state before fetching, and either a [_Success] state
  /// with the calendar data or a [_Failure] state if an error occurs.
  ///
  /// The [forceRefresh] parameter can be used to bypass the cached data
  /// and force a new network request.
  Future<void> fetchCustomAcademicCalendar({
    required int year,
    required int month,
    required String unit,
    bool forceRefresh = false,
  }) async {
    final current = state;

    if (!forceRefresh && current is _Success) {
      return;
    }

    emit(_Loading());

    try {
      final result = await _academicCalendarRepository
          .fetchCustomAcademicCalendar(unit: unit, month: month, year: year);

      final listAcademicCalendar = result.listAcademicCalendar;

      final DateTime now = DateTime.now();

      emit(
        _Success(
          listAcademicCalendar: listAcademicCalendar,
          year: year,
          month: month,
          lastUpdated: now,
        ),
      );
    } catch (e, st) {
      print("${e.toString()}, ${st.toString()}");
      emit(_Failure(e.toString()));
    }
  }

  @override
  AcademicCalendarState? fromJson(Map<String, dynamic> json) {
    try {
      final stateType = json['state'] as String?;
      if (stateType == null) return const _Initial();

      switch (stateType) {
        case 'success':
          final year = json['year'] as int;
          final month = json['month'] as int;
          final lastUpdatedMillis = json['lastUpdated'] as int?;
          final lastUpdated = lastUpdatedMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(lastUpdatedMillis)
              : DateTime.now();

          final listJson = (json['list'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
          final academicCalendar = listJson
              .map((m) => AcademicCalendar.fromJson(m))
              .toList();
          return _Success(
            listAcademicCalendar: academicCalendar,
            year: year,
            month: month,
            lastUpdated: lastUpdated,
          );

        case 'failure':
          final message = json['message'] as String? ?? 'Unknown';
          return _Failure(message);

        case 'loading':
          return const _Loading();

        case 'initial':
        default:
          return const _Initial();
      }
    } catch (_) {
      // If parsing fails for any reason, discard the cached state
      // and start fresh to avoid corruption.
      return const _Initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AcademicCalendarState state) {
    return state.when<Map<String, dynamic>?>(
      initial: () => {'state': 'initial'},
      loading: () => {'state': 'loading'},
      success: (academicCalendarList, year, month, lastUpdated) {
        // Convert the list of DailyAttendance objects to a list of JSON maps.
        final listJson = academicCalendarList.map((d) => d.toJson()).toList();
        return {
          'state': 'success',
          'year': year,
          'month': month,
          // Store the timestamp as milliseconds since epoch for simple serialization.
          'lastUpdated': lastUpdated.millisecondsSinceEpoch,
          'list': listJson,
        };
      },
      failure: (message) => {'state': 'failure', 'message': message},
    );
  }
}
