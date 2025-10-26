import 'dart:convert';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/services.dart';

/// An abstract class to manage languages within the application.
abstract class AppTranslation {
  /// Stores translation keys and their corresponding values for different languages.
  ///
  /// The outer map's key is the language code (e.g., 'en', 'id'),
  /// and the value is another map containing translation keys and their translated strings.
  static Map<String, Map<String, dynamic>> translationsKeys = Map.fromEntries(
    appLanguages
        .map((appLanguage) => appLanguage.languageCode)
        .toList()
        .map(
          (languageCode) =>
              MapEntry(languageCode, Map<String, String>.from({})),
        ),
  );

  /// Loads translation files from JSON assets for each supported language.
  ///
  /// This method iterates through the language codes defined in [translationsKeys],
  /// loads the corresponding JSON file from the 'assets/languages/' directory,
  /// decodes the JSON string, and populates the [translationsKeys] map
  /// with the translations for each language.
  static Future<void> loadJsons() async {
    for (var languageCode in translationsKeys.keys) {
      final String jsonStringValues = await rootBundle.loadString(
        'assets/languages/$languageCode.json',
      );

      // Decode value from rootBundle
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

      translationsKeys[languageCode] = mappedJson.cast<String, String>();
    }
  }
}
