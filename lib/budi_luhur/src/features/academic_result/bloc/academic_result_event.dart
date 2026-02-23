part of 'academic_result_bloc.dart';

@freezed
abstract class AcademicResultEvent with _$AcademicResultEvent {
  const factory AcademicResultEvent.fetchResult({
    @Default(false) bool forceRefresh,
  }) = _FetchResult;

  const factory AcademicResultEvent.refreshResult({
    @Default(true) bool forceRefresh,
  }) = _RefreshResult;
}
