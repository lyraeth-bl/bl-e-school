import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/device_tokens/data/datasources/device_token_local_data_source.dart';
import 'package:fpdart/fpdart.dart';

class DeviceTokenRepositoryImpl implements DeviceTokenRepository {
  final DeviceTokenRemoteDataSource _remoteDataSource;
  final DeviceTokenLocalDataSource _localDataSource;

  DeviceTokenRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<DeviceTokenResponse>> postDeviceToken() async {
    final response = await _remoteDataSource.postDeviceToken();

    return response.fold(
      (failure) => Left(failure),
      (DeviceTokenResponse deviceTokenResponse) async =>
          Right(deviceTokenResponse),
    );
  }

  @override
  DeviceToken? getStoredDeviceToken() =>
      _localDataSource.getStoredDeviceToken();

  @override
  Future<Unit> storeDeviceToken(DeviceToken deviceToken) async =>
      _localDataSource.storeDeviceToken(deviceToken);
}
