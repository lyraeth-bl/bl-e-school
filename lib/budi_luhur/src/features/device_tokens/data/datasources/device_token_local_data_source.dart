import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

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
