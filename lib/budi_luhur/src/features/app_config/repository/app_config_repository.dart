import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class AppConfigRepository {
  Future<Result<AppConfigResponse>> fetchAppConfig();

  AppConfig? getStoredAppConfig();

  Future<Unit> storeAppConfig(AppConfig appConfig);
}
