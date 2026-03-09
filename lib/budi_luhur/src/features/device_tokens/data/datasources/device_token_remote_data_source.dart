import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class DeviceTokenRemoteDataSource {
  Future<Result<DeviceTokenResponse>> postDeviceToken();
}

class DeviceTokenRemoteDataSourceImpl implements DeviceTokenRemoteDataSource {
  @override
  Future<Result<DeviceTokenResponse>> postDeviceToken() async {
    late Map<String, dynamic> data;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final platform = Platform.isIOS ? "ios" : "android";
    final version = packageInfo.version;

    data = DeviceTokenRequest(
      token: fcmToken,
      platform: platform,
      appVersion: version,
    ).toJson();

    try {
      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.deviceTokensSanctum,
      );

      return Right(DeviceTokenResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
