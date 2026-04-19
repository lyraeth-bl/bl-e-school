import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/device_token_request/device_token_request.dart';

abstract class DeviceTokenRemoteDataSource {
  Future<Result<Unit>> registerFcmToken({
    required String token,
    required String platform,
    String? appVersion,
  });

  Future<Result<Unit>> removeFcmToken({required String token});
}

class DeviceTokenRemoteDataSourceImpl implements DeviceTokenRemoteDataSource {
  @override
  Future<Result<Unit>> registerFcmToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    late Map<String, dynamic> data;

    data = DeviceTokenRequest(
      token: token,
      platform: platform,
      appVersion: appVersion,
    ).toJson();

    try {
      await ApiClient.post(body: data, url: ApiEndpoints.deviceTokensSanctum);

      return Right(unit);
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }

  @override
  Future<Result<Unit>> removeFcmToken({required String token}) async {
    final Map<String, dynamic> data = {'token': token};

    try {
      await ApiClient.delete(url: ApiEndpoints.deviceTokensSanctum, data: data);

      return Right(unit);
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }
}
