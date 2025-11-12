import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

/// A utility class for handling biometric authentication.
///
/// This class provides a simple interface to authenticate the user using
/// Touch ID, Face ID, or fingerprint scanning.
class BiometricAuth {
  /// The reason for requesting biometric authentication.
  ///
  /// This is displayed to the user during the authentication prompt.
  final String? reason;

  /// Creates an instance of [BiometricAuth].
  ///
  /// The [reason] is an optional message to show to the user.
  BiometricAuth(this.reason);

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  /// Attempts to authenticate the user using biometrics.
  ///
  /// Returns `true` if authentication is successful, `false` otherwise.
  ///
  /// This method checks for device support and registered biometrics before
  /// attempting to authenticate. It also handles platform exceptions and
  /// other potential errors.
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
        localizedReason: reason ?? "Authentikasi untuk melanjutkan",
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
