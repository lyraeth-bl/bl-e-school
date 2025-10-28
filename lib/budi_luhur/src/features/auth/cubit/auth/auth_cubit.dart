import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

/// A [Cubit] for managing the application's authentication state.
///
/// This cubit determines whether a user is currently logged in or not,
/// and provides methods to handle authentication, sign-out, and retrieval
/// of user details. It relies on an [AuthRepository] to persist and
/// retrieve authentication data.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  /// Creates an instance of [AuthCubit].
  ///
  /// Upon creation, it immediately checks the current authentication status
  /// by calling [_checkIsAuthenticated].
  AuthCubit(this._authRepository) : super(_Initial()) {
    _checkIsAuthenticated();
  }

  /// Checks the persisted authentication state to determine if the user is logged in.
  ///
  /// If the user is logged in, it emits an [_Authenticated] state with the
  /// user's data. Otherwise, it emits an [_Unauthenticated] state.
  void _checkIsAuthenticated() {
    if (_authRepository.getIsLogIn()) {
      emit(
        _Authenticated(
          jwtToken: _authRepository.getJwtToken(),
          isStudent: AuthRepository.getIsStudentLogIn(),
          student: AuthRepository.getIsStudentLogIn()
              ? AuthRepository.getStudentDetails()
              : Student.fromJson({}),
        ),
      );
    } else {
      emit(_Unauthenticated());
    }
  }

  /// Authenticates the user and persists their session data.
  ///
  /// This method saves the user's details, token, and login status to
  /// local storage via the [_authRepository] and emits an [_Authenticated] state.
  ///
  /// - [unit]: The school code or unit identifier.
  /// - [jwtToken]: The JSON Web Token for the user's session.
  /// - [isStudent]: A boolean indicating if the user is a student.
  /// - [student]: The [Student] object containing the user's details.
  void authenticateUser({
    required String jwtToken,
    required bool isStudent,
    required Student student,
  }) {
    _authRepository.setJwtToken(jwtToken);
    _authRepository.setIsLogIn(true);
    _authRepository.setIsStudentLogIn(isStudent);
    _authRepository.setStudentDetails(student);

    emit(
      _Authenticated(
        jwtToken: jwtToken,
        student: student,
        isStudent: isStudent,
      ),
    );
  }

  /// Retrieves the [Student] details if the user is authenticated.
  ///
  /// Returns the current [Student] object from the state. If the user is
  /// not authenticated, it returns an empty [Student] object.
  Student getStudentDetails() {
    return state.maybeWhen(
      authenticated: (jwtToken, isStudent, student) => student,
      orElse: () => Student.fromJson({}),
    );
  }

  /// Signs the user out of the application.
  ///
  /// This method clears all authentication data from local storage
  /// via the [_authRepository] and emits an [_Unauthenticated] state.
  void signOut() {
    _authRepository.signOutUser();
    emit(_Unauthenticated());
  }
}
