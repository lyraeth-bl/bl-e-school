part of 'extracurricular_bloc.dart';

@freezed
abstract class ExtracurricularState with _$ExtracurricularState {
  const factory ExtracurricularState.initial() = _Initial;

  const factory ExtracurricularState.loading() = _Loading;

  const factory ExtracurricularState.success({
    required List<Extracurricular> extracurricularList,
  }) = _Success;

  const factory ExtracurricularState.failure(Failure failure) = _Failure;
}
