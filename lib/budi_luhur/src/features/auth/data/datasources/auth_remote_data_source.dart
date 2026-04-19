import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/login_request/login_request.dart';
import '../model/login_response/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest);

  Future<Unit> logoutSanctum();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest) async {
    final data = loginRequest.toJson();

    try {
      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.loginSanctum,
        extra: {"skipAuthInterceptor": true},
      );

      return Right(LoginResponse.fromJson(response));
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }

  @override
  Future<Unit> logoutSanctum() async {
    try {
      await ApiClient.post(body: {}, url: ApiEndpoints.logoutSanctum);
    } catch (e) {
      //
    }

    return unit;
  }
}
