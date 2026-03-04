import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class AppConfigRemoteDataSource {
  Future<Result<AppConfigResponse>> fetchAppConfig();
}

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  @override
  Future<Result<AppConfigResponse>> fetchAppConfig() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.appConfig);

      return Right(AppConfigResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
