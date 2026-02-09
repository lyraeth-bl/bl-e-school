part of 'discipline_bloc.dart';

@freezed
abstract class DisciplineState with _$DisciplineState {
  const factory DisciplineState.initial() = _Initial;

  const factory DisciplineState.loading() = _Loading;

  const factory DisciplineState.loaded({
    required List<Merit> meritList,
    required List<Demerit> demeritList,
    required int totalMerit,
    required int totalDemerit,
  }) = _Loaded;

  const factory DisciplineState.error(String message) = _Error;

  factory DisciplineState.fromJson(Map<String, dynamic> json) =>
      _$DisciplineStateFromJson(json);
}
