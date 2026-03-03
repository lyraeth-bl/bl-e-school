import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/model/login_request/login_request.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/model/login_response/login_response.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Unit> closeAndDeleteBox() async =>
      _authLocalDataSource.closeAndDeleteBox();

  @override
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest) async {
    final response = await _authRemoteDataSource.loginSanctum(loginRequest);

    return response.fold((failure) => Left(failure), (
      LoginResponse loginResponse,
    ) async {
      return Right(loginResponse);
    });
  }

  @override
  Future<Unit> logoutSanctum() async {
    await _authRemoteDataSource.logoutSanctum();

    return unit;
  }
}
