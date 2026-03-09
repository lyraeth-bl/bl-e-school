part of 'sessions_bloc.dart';

@freezed
abstract class SessionsEvent with _$SessionsEvent {
  const factory SessionsEvent.started() = _Started;

  const factory SessionsEvent.loggedIn({required String token}) = _LoggedIn;

  const factory SessionsEvent.loggedOut() = _LoggedOut;
}
