part of 'discipline_bloc.dart';

@freezed
abstract class DisciplineEvent with _$DisciplineEvent {
  const factory DisciplineEvent.fetchMeritAndDemerit({
    String? schoolSession,
    String? semester,
    @Default(false) bool forceRefresh,
  }) = _FetchMeritAndDemerit;
}
