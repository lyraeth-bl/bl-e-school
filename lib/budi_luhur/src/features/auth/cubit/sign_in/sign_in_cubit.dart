import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_cubit.freezed.dart';
part 'sign_in_state.dart';

/// A [Cubit] for managing the user sign-in process.
///
/// This cubit coordinates the authentication flow by interacting with the
/// [AuthRepository]. It emits states corresponding to the different stages
/// of the sign-in process, such as loading, success, and failure.
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  /// Creates an instance of [SignInCubit].
  ///
  /// Requires an [AuthRepository] to handle the underlying authentication logic.
  SignInCubit(this._authRepository) : super(const _Initial());

  /// Attempts to sign in a user with the provided credentials.
  ///
  /// This method orchestrates the sign-in process:
  /// 1. Emits a [_Loading] state to indicate the start of the process.
  /// 2. Calls the appropriate sign-in method on the [_authRepository].
  /// 3. On success, emits a [_Success] state with the authenticated user's data.
  /// 4. On failure, emits a [_Failure] state with an error message.
  ///
  /// - [nis]: The user's NIS (Nomor Induk Siswa).
  /// - [password]: The user's password.
  /// - [isStudentLogIn]: A flag to determine if the user is a student.
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
          jwtToken: result['jwtToken'],
          isStudentLogIn: isStudentLogIn,
          student: isStudentLogIn ? result['student'] : Student.fromJson({}),
        ),
      );
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
