import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive/hive.dart';

/// A repository for managing user settings, stored locally using Hive.
///
/// This class provides methods to persist and retrieve application settings,
/// such as the current language and biometric authentication status.
class SettingsRepository {
  /// Saves the user's selected language code to local storage.
  ///
  /// [value] is the language code (e.g., 'en', 'id') to be saved.
  Future<void> setCurrentLanguageCode(String value) async {
    Hive.box(settingsBoxKey).put(currentLanguageCodeKey, value);
  }

  /// Retrieves the currently selected language code from local storage.
  ///
  /// If no language code is found, it returns the [defaultLanguageCode].
  String getCurrentLanguageCode() {
    return Hive.box(settingsBoxKey).get(currentLanguageCodeKey) ??
        defaultLanguageCode;
  }

  /// Saves the biometric authentication status to local storage.
  ///
  /// [value] is `true` to enable biometric authentication, `false` to disable it.
  Future<void> setBiometricStatus(bool value) async {
    return Hive.box(authBoxKey).put(biometricStatusKey, value);
  }

  /// Retrieves the biometric authentication status from local storage.
  ///
  /// Returns `true` if biometric authentication is enabled, otherwise `false`.
  /// Defaults to `false` if the value is not found.
  bool getBiometricStatus() {
    return Hive.box(authBoxKey).get(biometricStatusKey) ?? false;
  }
}
