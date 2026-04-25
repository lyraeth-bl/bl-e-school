import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';

abstract class DeviceTokenRepository {
  Future<Result<Unit>> registerFcmToken({
    required String token,
    required String platform,
    String? appVersion,
  });

  Future<Result<Unit>> removeFcmToken({required String token});
}
