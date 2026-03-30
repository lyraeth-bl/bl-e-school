import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class DeviceTokenRepository {
  Future<Result<Unit>> registerFcmToken({
    required String token,
    required String platform,
    String? appVersion,
  });

  Future<Result<Unit>> removeFcmToken({required String token});
}
