part of 'sessions_bloc.dart';

@freezed
abstract class SessionsState with _$SessionsState {
  const factory SessionsState.initial() = _Initial;

  const factory SessionsState.firstTime() = _FirstTime;

  const factory SessionsState.loading() = _Loading;

  const factory SessionsState.authenticated({
    Student? student,
    required String accessToken,
  }) = _Authenticated;

  const factory SessionsState.unauthenticated() = _Unauthenticated;
}
