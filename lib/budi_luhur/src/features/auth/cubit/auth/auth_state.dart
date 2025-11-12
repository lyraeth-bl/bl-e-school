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
  /// - [isStudent]: A flag indicating whether the authenticated user is a student. Defaults to `false`.
  /// - [student]: The [Student] object containing the details of the authenticated user.
  /// - [timeAuth]: The [DateTime] when the authentication occurred.
  const factory AuthState.authenticated({
    @Default(false) bool isStudent,
    required Student student,
    DateTime? timeAuth,
  }) = _Authenticated;
}
