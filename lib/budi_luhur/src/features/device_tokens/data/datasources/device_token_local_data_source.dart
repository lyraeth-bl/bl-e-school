import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/device_token.dart';

abstract class DeviceTokenLocalDataSource {
  DeviceToken? getStoredDeviceToken();

  Future<Unit> storeDeviceToken(DeviceToken deviceToken);
}

class DeviceTokenLocalDataSourceImpl implements DeviceTokenLocalDataSource {
  @override
  DeviceToken? getStoredDeviceToken() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsDeviceTokenKey);

    if (raw == null) return null;

    return DeviceToken.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<Unit> storeDeviceToken(DeviceToken deviceToken) async {
    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsDeviceTokenKey, deviceToken.toJson());

    return unit;
  }
}
