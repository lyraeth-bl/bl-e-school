part of 'academic_calendar_cubit.dart';

/// Represents the state of the academic calendar feature.
@freezed
abstract class AcademicCalendarState with _$AcademicCalendarState {
  /// The initial state of the academic calendar.
  const factory AcademicCalendarState.initial() = _Initial;

  /// The state when the academic calendar is being loaded.
  const factory AcademicCalendarState.loading() = _Loading;

  /// The state when the academic calendar has been successfully loaded.
  const factory AcademicCalendarState.success({
    /// The list of academic calendar items.
    required List<AcademicCalendar> listAcademicCalendar,

    /// The year of the academic calendar.
    required int year,

    /// The month of the academic calendar.
    required int month,

    /// The last time the academic calendar was updated.
    required DateTime lastUpdated,
  }) = _Success;

  /// The state when an error has occurred while loading the academic calendar.
  const factory AcademicCalendarState.failure(
    /// The error message.
    String errorMessage,
  ) = _Failure;
}
