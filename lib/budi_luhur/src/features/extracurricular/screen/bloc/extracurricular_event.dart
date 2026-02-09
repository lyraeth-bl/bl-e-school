part of 'extracurricular_bloc.dart';

@freezed
abstract class ExtracurricularEvent with _$ExtracurricularEvent {
  const factory ExtracurricularEvent.fetchExtracurricular({
    required String nis,
    @Default(false) bool forceRefresh,
  }) = _FetchExtracurriculer;

  const factory ExtracurricularEvent.refresh({
    required String nis,
    @Default(true) bool forceRefresh,
  }) = _Refresh;
}
