part of 'academic_result_bloc.dart';

@freezed
abstract class AcademicResultState with _$AcademicResultState {
  const factory AcademicResultState.initial() = _Initial;

  const factory AcademicResultState.loading() = _Loading;

  const factory AcademicResultState.success({
    required AcademicResultResponse response,
    required List<String> subjectNames,
  }) = _Success;

  const factory AcademicResultState.failure(String errorMessage) = _Failure;
}
