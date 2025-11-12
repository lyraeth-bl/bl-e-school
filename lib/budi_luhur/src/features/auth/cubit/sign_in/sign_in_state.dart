part of 'sign_in_cubit.dart';

/// Represents the different states of the sign-in process.
///
/// This sealed class, built with `freezed`, defines the possible states
/// for the [SignInCubit], from initial to loading, success, and failure.
@freezed
abstract class SignInState with _$SignInState {
  /// The initial state before any sign-in action has been taken.
  const factory SignInState.initial() = _Initial;

  /// The state indicating that the sign-in process is currently in progress.
  const factory SignInState.loading() = _Loading;

  /// The state representing a successful sign-in.
  ///
  /// This state carries the data associated with the authenticated user.
  const factory SignInState.success({
    /// A flag indicating if the logged-in user is a student.
    required bool isStudentLogIn,

    /// The [Student] object with the user's details.
    required Student student,

    /// The timestamp of the successful login.
    DateTime? timeLogin,
  }) = _Success;

  /// The state representing a failed sign-in attempt.
  const factory SignInState.failure(
    /// A message describing the reason for the failure.
    String errorMessage,
  ) = _Failure;
}
