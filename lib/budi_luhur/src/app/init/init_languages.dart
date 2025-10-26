import 'dart:convert';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/services.dart';

/// A Abstract Class to manage languages on the app.
abstract class AppTranslation {
  static Map<String, Map<String, dynamic>> translationsKeys = Map.fromEntries(
    appLanguages
        .map((appLanguage) => appLanguage.languageCode)
        .toList()
        .map(
          (languageCode) =>
              MapEntry(languageCode, Map<String, String>.from({})),
        ),
  );

  static Future loadJsons() async {
    for (var languageCode in translationsKeys.keys) {
      final String jsonStringValues = await rootBundle.loadString(
        'assets/languages/$languageCode.json',
      );

      // Encode value from rootBundle
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

      translationsKeys[languageCode] = mappedJson.cast<String, String>();
    }
  }
}
