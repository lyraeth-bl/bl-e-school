part of 'discipline_bloc.dart';

@freezed
abstract class DisciplineState with _$DisciplineState {
  const factory DisciplineState.initial() = _Initial;

  const factory DisciplineState.loading() = _Loading;

  const factory DisciplineState.success({
    required List<Merit> meritList,
    required List<Demerit> demeritList,
    int? totalMerit,
    int? totalDemerit,
  }) = _Success;

  const factory DisciplineState.failure(Failure failure) = _Failure;
}
