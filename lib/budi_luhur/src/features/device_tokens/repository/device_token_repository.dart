import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class DeviceTokenRepository {
  Future<Result<DeviceTokenResponse>> postDeviceToken();

  DeviceToken? getStoredDeviceToken();

  Future<Unit> storeDeviceToken(DeviceToken deviceToken);
}
