import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

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
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(cancelButton: 'No thanks'),
        ],
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
