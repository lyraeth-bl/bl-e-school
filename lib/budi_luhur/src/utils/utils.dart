library;

import 'dart:ui';

/// Hive Box Keys
export 'shared/hive_box_keys/hive_box_keys.dart';
/// Languages
export 'shared/languages/app_languages.dart';
/// Theme
export 'shared/theme/theme.dart';

class Utils {
  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }
}
