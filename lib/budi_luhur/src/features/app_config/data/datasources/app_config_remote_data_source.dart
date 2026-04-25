import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/app_config_response/app_config_response.dart';

abstract class AppConfigRemoteDataSource {
  Future<Result<AppConfigResponse>> fetchAppConfig();
}

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  @override
  Future<Result<AppConfigResponse>> fetchAppConfig() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.appConfigSanctum);

      return Right(AppConfigResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
