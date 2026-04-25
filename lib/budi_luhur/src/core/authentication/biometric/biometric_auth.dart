import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final String reason;

  BiometricAuth(this.reason);

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> biometricAuth() async {
    try {
      final isSupported = await _localAuthentication.isDeviceSupported();

      if (!isSupported) {
        debugPrint("Biometric : Device ini tidak support biometric");
        return false;
      }

      final canCheckBiometric = await _localAuthentication.canCheckBiometrics;

      if (!canCheckBiometric) {
        debugPrint("Biometric : Tidak ada biometric yang teregister");
        return false;
      }

      return await _localAuthentication.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      debugPrint("Biometric error: ${e.code} - ${e.message}");
      return false;
    } catch (e) {
      debugPrint('Unknown biometric error: $e');
      return false;
    }
  }
}
