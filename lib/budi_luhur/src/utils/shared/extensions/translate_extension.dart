import '../../utils.dart';

/// An extension on [String] to simplify the process of translating text.
///
/// This extension provides a `tr` method that serves as a shorthand for accessing
/// the app's localization functionality.
///
/// Example:
///
/// ```dart
/// // Assuming you have a localization key 'home_title' defined.
/// // Instead of calling a long static method, you can do this:
///
/// Text('home_title'.tr(context))
/// ```
///
/// This will look up the translation for the key 'home_title' and display the
/// appropriate text based on the current locale.
extension TranslateExtension on String {
  /// Translates the string using the app's localization logic.
  ///
  /// This method is a convenient shortcut for `Utils.getTranslatedLabel(this)`.
  /// It fetches the translated value for the current string, which is treated as a key.
  String translate() {
    return Utils.getTranslatedLabel(this);
  }
}
