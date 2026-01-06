import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

/// Manages the application's authentication state, including user details and login status.
///
/// This Cubit extends [HydratedCubit] to automatically persist and restore
/// the authentication state, providing a seamless user experience across app restarts.
class AuthCubit extends HydratedCubit<AuthState> {
  final AuthRepository _authRepository;
  final BiometricAuth _biometricAuth;

  /// Creates an instance of [AuthCubit].
  ///
  /// Requires an [AuthRepository] for handling authentication logic and a
  /// [BiometricAuth] utility for biometric operations.
  AuthCubit(this._authRepository, this._biometricAuth)
    : super(const _Initial()) {
    _init();
  }

  bool _hasLoggedOut = false;

  /// Initializes the authentication state when the cubit is first created.
  ///
  /// It checks the persisted login status from the repository. If the user is
  /// not logged in, it emits an `unauthenticated` state. Otherwise, it attempts
  /// to restore the authenticated state from storage or fetches fresh user
  /// data if no state was restored.
  void _init() {
    if (!_authRepository.getIsLogIn()) {
      emit(const AuthState.unauthenticated());
      return;
    }

    final current = state;
    final isAlreadyAuth = current.maybeWhen(
      authenticated: (isStudent, student, timeAuth) => true,
      orElse: () => false,
    );

    if (isAlreadyAuth) {
      // State has been successfully restored by HydratedCubit.
      return;
    }

    // If state wasn't restored, fetch data from the repository.
    try {
      final student = AuthRepository.getStudentDetails();
      final isStudent = AuthRepository.getIsStudentLogIn();
      final timeAuth = getTimeLogin;

      emit(
        _Authenticated(
          isStudent: isStudent,
          student: student,
          timeAuth: timeAuth,
        ),
      );
    } catch (e) {
      // If fetching fails, revert to unauthenticated state.
      emit(const AuthState.unauthenticated());
    }
  }

  /// Attempts to refresh the user's session using biometric authentication.
  ///
  /// Returns `true` on successful refresh, `false` otherwise.
  /// This is typically used to re-authenticate the user after a period of inactivity.
  Future<bool> biometricRefreshToken() async {
    try {
      final isBiometricStatusActive = SettingsRepository().getBiometricStatus();
      if (!isBiometricStatusActive) return false;

      final isAuthenticated = await _biometricAuth.biometricAuth();
      if (!isAuthenticated) return false;

      final lastJwtToken = _authRepository.getJwtToken();
      if (lastJwtToken.isEmpty) return false;

      try {
        await _authRepository.refreshToken();
      } catch (e) {
        debugPrint("RefreshTokenError : ${e.toString()}");
        return false;
      }

      final student = AuthRepository.getStudentDetails();
      final isStudent = AuthRepository.getIsStudentLogIn();
      final nowTime = DateTime.now();

      emit(
        _Authenticated(
          isStudent: isStudent,
          student: student,
          timeAuth: nowTime,
        ),
      );

      return true;
    } catch (e) {
      debugPrint("biometricRefreshTokenError: ${e.toString()}");
      return false;
    }
  }

  /// Manually sets the authentication state to authenticated.
  ///
  /// This is used after a successful login or registration to update the app state.
  void authenticateUser({
    DateTime? time,
    required bool isStudent,
    required Student student,
  }) {
    _hasLoggedOut = false;
    emit(
      _Authenticated(isStudent: isStudent, student: student, timeAuth: time),
    );
  }

  /// Gets the [Student] details from the current authenticated state.
  ///
  /// Returns an empty [Student] object if the user is not authenticated.
  Student get getStudentDetails => state.maybeWhen(
    authenticated: (isStudent, student, timeAuth) => student,
    orElse: () => Student.fromJson({}),
  );

  /// Checks if the currently authenticated user is a student.
  ///
  /// Returns `false` if the user is not authenticated.
  bool get getIsStudentLogin => state.maybeWhen(
    authenticated: (isStudent, student, timeAuth) => isStudent,
    orElse: () => false,
  );

  /// Gets the timestamp of the last authentication.
  ///
  /// Returns the current time if the user is not authenticated or if the time is not set.
  DateTime get getTimeLogin => state.maybeWhen(
    authenticated: (isStudent, student, timeAuth) => timeAuth ?? DateTime.now(),
    orElse: () => DateTime.now(),
  );

  /// Retrieves the current JWT token from the repository.
  String get getJwtToken => _authRepository.getJwtToken();

  /// Signs the user out and transitions to the unauthenticated state.
  void signOut({LogoutReason reason = LogoutReason.manual}) async {
    if (_hasLoggedOut) return;
    _hasLoggedOut = true;

    await _authRepository.signOutUser();
    emit(AuthState.unauthenticated(reason: reason));
  }

  // -------------------------------
  // Hydrated: State Persistence
  // -------------------------------

  /// Deserializes the JSON map into an [AuthState] object.
  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'authenticated':
        final m = (json['student'] as Map?)?.cast<String, dynamic>();
        if (m == null) return const AuthState.unauthenticated();
        final timeStr = json['timeAuth'] as String?;
        final time = timeStr == null ? null : DateTime.tryParse(timeStr);
        return AuthState.authenticated(
          isStudent: (json['isStudent'] as bool?) ?? false,
          student: Student.fromJson(m),
          timeAuth: time,
        );
      case 'unauthenticated':
        return const AuthState.unauthenticated();
      case 'initial':
      default:
        return const AuthState.initial();
    }
  }

  /// Serializes the current [AuthState] into a JSON map for storage.
  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.map(
      initial: (_) => {'type': 'initial'},
      unauthenticated: (_) => {'type': 'unauthenticated'},
      authenticated: (s) => {
        'type': 'authenticated',
        'isStudent': s.isStudent,
        'student': s.student.toJson(),
        'timeAuth': s.timeAuth?.toIso8601String(),
      },
    );
  }
}
