import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class DeviceTokenRepositoryImpl implements DeviceTokenRepository {
  final DeviceTokenRemoteDataSource _remoteDataSource;

  DeviceTokenRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Unit>> registerFcmToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    final response = await _remoteDataSource.registerFcmToken(
      token: token,
      platform: platform,
      appVersion: appVersion,
    );

    return response.match((failure) => Left(failure), (res) => Right(unit));
  }

  @override
  Future<Result<Unit>> removeFcmToken({required String token}) async {
    final response = await _remoteDataSource.removeFcmToken(token: token);

    return response.match((failure) => Left(failure), (res) => Right(unit));
  }
}
