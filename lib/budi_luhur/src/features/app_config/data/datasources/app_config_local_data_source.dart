import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/app_config/app_config.dart';

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
