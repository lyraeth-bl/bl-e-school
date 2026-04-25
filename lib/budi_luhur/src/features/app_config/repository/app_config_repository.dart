import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/app_config/app_config.dart';
import '../data/model/app_config_response/app_config_response.dart';

abstract class AppConfigRepository {
  Future<Result<AppConfigResponse>> fetchAppConfig();

  AppConfig? getStoredAppConfig();

  Future<Unit> storeAppConfig(AppConfig appConfig);
}
