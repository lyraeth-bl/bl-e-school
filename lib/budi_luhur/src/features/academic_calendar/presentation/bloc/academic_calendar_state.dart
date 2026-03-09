part of 'academic_calendar_bloc.dart';

@freezed
abstract class AcademicCalendarState with _$AcademicCalendarState {
  const factory AcademicCalendarState.initial() = _Initial;

  const factory AcademicCalendarState.loading() = _Loading;

  const factory AcademicCalendarState.success({
    required List<AcademicCalendar> listAcademicCalendar,
    required int year,
    required int month,
    required DateTime lastUpdated,
  }) = _Success;

  const factory AcademicCalendarState.failure(Failure failure) = _Failure;
}
