import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/datasources/app_config_local_data_source.dart';
import '../data/datasources/app_config_remote_data_source.dart';
import '../data/model/app_config/app_config.dart';
import '../data/model/app_config_response/app_config_response.dart';
import 'app_config_repository.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  final AppConfigRemoteDataSource _remoteDataSource;
  final AppConfigLocalDataSource _localDataSource;

  AppConfigRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Result<AppConfigResponse>> fetchAppConfig() async {
    final response = await _remoteDataSource.fetchAppConfig();

    return response.match(
      (failure) => Left(failure),
      (AppConfigResponse appConfigResponse) => Right(appConfigResponse),
    );
  }

  @override
  AppConfig? getStoredAppConfig() => _localDataSource.getStoredAppConfig();

  @override
  Future<Unit> storeAppConfig(AppConfig appConfig) async =>
      await _localDataSource.storeAppConfig(appConfig);
}
