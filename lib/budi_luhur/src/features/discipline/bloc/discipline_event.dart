part of 'discipline_bloc.dart';

@freezed
abstract class DisciplineEvent with _$DisciplineEvent {
  const factory DisciplineEvent.load({
    required String nis,
    String? schoolSession,
    String? semester,
    @Default(false) bool forceRefresh,
  }) = _Load;

  const factory DisciplineEvent.refresh({
    required String nis,
    String? schoolSession,
    String? semester,
    @Default(true) bool forceRefresh,
  }) = _Refresh;
}
