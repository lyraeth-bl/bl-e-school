import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest);

  Future<Unit> logoutSanctum();

  Future<Unit> closeAndDeleteBox();
}
