import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

abstract class AppConfigLocalDataSource {
  AppConfig? getStoredAppConfig();

  Future<Unit> storeAppConfig(AppConfig appConfig);
}

class AppConfigLocalDataSourceImpl implements AppConfigLocalDataSource {
  @override
  AppConfig? getStoredAppConfig() {
    final raw = Hive.box(settingsBoxKey).get(settingsAppConfigKey);

    if (raw == null) return null;

    return AppConfig.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<Unit> storeAppConfig(AppConfig appConfig) async {
    await Hive.box(
      settingsBoxKey,
    ).put(settingsAppConfigKey, appConfig.toJson());

    return unit;
  }
}
