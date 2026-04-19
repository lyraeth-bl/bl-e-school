import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failure/failure.dart';
import '../../notifications/fcm_service.dart';
import '../data/model/login_request/login_request.dart';
import '../data/model/login_response/login_response.dart';
import '../repository/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<_LoginRequested>(_onLoginRequested);
    on<_LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    _LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.loginSanctum(
      LoginRequest(
        nis: event.loginRequest.nis,
        password: event.loginRequest.password,
      ),
    );

    return result.match(
      (failure) => emit(AuthState.failure(failure)),
      (LoginResponse loginResponse) => emit(
        AuthState.successLogin(
          accessToken: loginResponse.accessToken,
          expiresAt: loginResponse.expiresAt,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    _LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!kIsWeb) {
      FcmService.instance.unregisterToken().ignore();
    }

    await _authRepository.logoutSanctum();
    emit(const AuthState.successLogout());
  }
}
