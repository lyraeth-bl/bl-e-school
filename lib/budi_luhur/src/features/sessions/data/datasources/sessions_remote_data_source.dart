import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/me_response/me_response.dart';

abstract class SessionsRemoteDataSource {
  Future<Result<MeResponse>> fetchMe();
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  @override
  Future<Result<MeResponse>> fetchMe() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.meSanctum);

      return Right(MeResponse.fromJson(response));
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }
}
