import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_cubit.freezed.dart';
part 'sign_in_state.dart';

/// {@template sign_in_cubit}
/// A [Cubit] for managing the user sign-in process.
///
/// This cubit coordinates the authentication flow by interacting with the
/// [AuthRepository]. It emits states corresponding to the different stages
/// of the sign-in process, such as loading, success, and failure.
/// {@endtemplate}
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  /// {@macro sign_in_cubit}
  ///
  /// Creates an instance of [SignInCubit].
  ///
  /// Requires an [AuthRepository] to handle the underlying authentication logic.
  SignInCubit(this._authRepository) : super(const _Initial());

  /// Attempts to sign in a user with the provided credentials.
  ///
  /// This method orchestrates the sign-in process:
  /// 1. Emits a [SignInState.loading] state to indicate the start of the process.
  /// 2. Calls the appropriate sign-in method on the [_authRepository] based on
  ///    the [isStudentLogIn] flag.
  /// 3. On success, emits a [SignInState.success] state with the authenticated
  ///    user's data.
  /// 4. On failure, emits a [SignInState.failure] state with an error message.
  ///
  /// - [nis]: The user's NIS (Nomor Induk Siswa).
  /// - [password]: The user's password.
  /// - [isStudentLogIn]: A flag to determine if the user is a student. This
  ///   governs which repository method is called.
  Future<void> signInUser({
    required String nis,
    required String password,
    required bool isStudentLogIn,
  }) async {
    emit(const _Loading());

    try {
      late Map<String, dynamic> result;

      if (isStudentLogIn) {
        result = await _authRepository.signInStudent(
          nis: nis,
          password: password,
        );
      }

      emit(
        _Success(
          isStudentLogIn: isStudentLogIn,
          student: isStudentLogIn ? result['student'] : Student.fromJson({}),
          timeLogin: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
