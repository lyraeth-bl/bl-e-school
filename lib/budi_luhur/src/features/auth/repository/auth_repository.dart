import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/login_request/login_request.dart';
import '../data/model/login_response/login_response.dart';

abstract class AuthRepository {
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest);

  Future<Unit> logoutSanctum();

  Future<Unit> closeAndDeleteBox();
}
