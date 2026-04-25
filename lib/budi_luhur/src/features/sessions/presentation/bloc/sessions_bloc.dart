import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/model/student/student.dart';
import '../../data/model/me_response/me_response.dart';
import '../../repository/sessions_repository.dart';

part 'sessions_bloc.freezed.dart';
part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionsRepository _sessionsRepository;

  SessionsBloc(this._sessionsRepository)
    : super(const SessionsState.initial()) {
    on<_Started>(_onStarted);
    on<_LoggedIn>(_onLoggedIn);
    on<_LoggedOut>(_onLoggedOut);
  }

  Future<void> _onStarted(_Started event, Emitter<SessionsState> emit) async {
    emit(const SessionsState.loading());

    final token = await _sessionsRepository.getAccessToken();
    debugPrint(
      "Token dari await _sessionsRepository.getAccessToken(); ${await _sessionsRepository.getAccessToken()}",
    );

    if (token == null) {
      emit(const SessionsState.unauthenticated());
      return;
    }

    final result = await _sessionsRepository.fetchMe();

    result.fold(
      (failure) async {
        await _sessionsRepository.clearSession();

        if (emit.isDone) return;

        emit(const SessionsState.unauthenticated());
      },
      (MeResponse me) {
        emit(SessionsState.authenticated(student: me.me, accessToken: token));
      },
    );
  }

  Future<void> _onLoggedIn(_LoggedIn event, Emitter<SessionsState> emit) async {
    emit(const SessionsState.loading());

    await _sessionsRepository.setAccessToken(event.token);

    await _sessionsRepository.setIsStudentLoggedIn(true);

    emit(SessionsState.tokenReady(accessToken: event.token));

    final result = await _sessionsRepository.fetchMe();

    final failure = result.fold((f) => f, (_) => null);
    final me = result.fold((_) => null, (m) => m);

    if (failure != null) {
      await _sessionsRepository.clearSession();
      emit(const SessionsState.unauthenticated());
      return;
    }

    if (me != null) {
      await _sessionsRepository.setLoggedStudentDetails(me.me);
      emit(
        SessionsState.authenticated(student: me.me, accessToken: event.token),
      );
    }
  }

  Future<void> _onLoggedOut(
    _LoggedOut event,
    Emitter<SessionsState> emit,
  ) async {
    await _sessionsRepository.clearSession();

    await _sessionsRepository.setIsStudentLoggedIn(false);

    emit(const SessionsState.unauthenticated());
  }

  Student? get studentDetails =>
      state.whenOrNull(authenticated: (student, accessToken) => student);
}
