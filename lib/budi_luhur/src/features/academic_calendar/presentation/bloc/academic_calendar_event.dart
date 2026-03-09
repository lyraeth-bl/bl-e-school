part of 'academic_calendar_bloc.dart';

@freezed
abstract class AcademicCalendarEvent with _$AcademicCalendarEvent {
  const factory AcademicCalendarEvent.fetch({
    required AcademicCalendarRequest academicCalendarRequest,
    @Default(false) bool forceRefresh,
  }) = _Fetch;
}
