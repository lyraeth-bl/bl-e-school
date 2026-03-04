import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

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
