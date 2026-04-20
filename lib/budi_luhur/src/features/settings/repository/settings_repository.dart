import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

import '../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../../../utils/shared/languages/app_languages.dart';

class SettingsRepository {
  Future<void> setCurrentLanguageCode(String value) async {
    Hive.box(settingsBoxKey).put(currentLanguageCodeKey, value);
  }

  String getCurrentLanguageCode() {
    return Hive.box(settingsBoxKey).get(currentLanguageCodeKey) ??
        defaultLanguageCode;
  }

  Future<void> setBiometricStatus(bool value) async {
    return Hive.box(settingsBoxKey).put(settingsBiometricStatusKey, value);
  }

  bool getBiometricStatus() {
    return Hive.box(settingsBoxKey).get(settingsBiometricStatusKey) ?? false;
  }

  Future<bool> getNotificationSettings() async {
    NotificationSettings notificationSettings = await FirebaseMessaging.instance
        .getNotificationSettings();

    if (notificationSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined ||
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.denied) {
      return false;
    } else {
      return true;
    }
  }
}
