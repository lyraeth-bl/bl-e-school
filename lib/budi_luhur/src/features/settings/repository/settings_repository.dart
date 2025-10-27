import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive/hive.dart';

/// A repository for managing user settings, stored locally using Hive.
///
/// This class provides methods to persist and retrieve application settings,
/// such as the current language.
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
}
