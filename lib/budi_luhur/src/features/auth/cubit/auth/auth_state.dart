part of 'auth_cubit.dart';

/// Represents the different states of authentication within the application.
///
/// This sealed class is used by the [AuthCubit] to manage and emit states
/// corresponding to whether a user is logged in, logged out, or in an
/// initial undetermined state.
@freezed
abstract class AuthState with _$AuthState {
  /// The initial state, representing that the authentication status has not yet been determined.
  const factory AuthState.initial() = _Initial;

  /// The state representing that the user is not authenticated.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// The state representing that the user is successfully authenticated.
  ///
  /// This state holds the authenticated user's session information.
  ///
  /// - [jwtToken]: The JSON Web Token for the user's session.
  /// - [isStudent]: A flag indicating whether the authenticated user is a student. Defaults to `false`.
  /// - [student]: The [Student] object containing the details of the authenticated user.
  /// - [unit]: The school code or unit identifier associated with the user.
  const factory AuthState.authenticated({
    required String jwtToken,
    @Default(false) bool isStudent,
    required Student student,
  }) = _Authenticated;
}
