part of 'auth_cubit.dart';

/// Defines the reason for logging out.
enum LogoutReason { manual, sessionExpired }

/// Represents the authentication state of the user.
@freezed
abstract class AuthState with _$AuthState {
  /// The initial authentication state.
  const factory AuthState.initial() = _Initial;

  /// The user is not authenticated.
  const factory AuthState.unauthenticated({
    /// The reason for being unauthenticated.
    @Default(LogoutReason.manual) LogoutReason reason,
  }) = _Unauthenticated;

  /// The user is authenticated.
  const factory AuthState.authenticated({
    /// A flag indicating if the user is a student.
    @Default(false) bool isStudent,

    /// The authenticated student.
    required Student student,

    /// The time of authentication.
    DateTime? timeAuth,
  }) = _Authenticated;
}
