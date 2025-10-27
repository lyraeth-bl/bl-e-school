library;

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Animations
export 'shared/animations/animation_configurations.dart';
/// Constant
export 'shared/constant/constant.dart';
/// Error Handling
export 'shared/error_handling/error_message_and_code.dart';
/// Hive Box Keys
export 'shared/hive_box_keys/hive_box_keys.dart';
/// Label Keys
export 'shared/label_keys/label_keys.dart';
/// Languages
export 'shared/languages/app_languages.dart';
/// Theme
export 'shared/theme/theme.dart';
/// UI
export 'shared/ui/ui.dart';

/// A utility class containing static helper methods for common tasks.
///
/// This class provides a collection of convenient functions that can be used
/// throughout the application, such as locale conversion, displaying custom snack bars,
/// and accessing theme properties.
class Utils {
  /// Converts a language code string into a [Locale] object.
  ///
  /// This method handles both simple language codes (e.g., "en") and codes
  /// with a country identifier (e.g., "en-US").
  ///
  /// - [languageCode]: The string to convert, such as "en" or "en-US".
  /// - Returns: A [Locale] object corresponding to the provided code.
  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  /// Displays a custom overlay message (similar to a snackbar).
  ///
  /// This function shows a custom widget as an overlay for a specified duration.
  /// It is typically used for displaying brief messages like errors or confirmations.
  ///
  /// - [context]: The build context from which to find the overlay.
  /// - [errorMessage]: The message to be displayed.
  /// - [backgroundColor]: The background color of the message container.
  /// - [delayDuration]: The duration for which the message will be visible.
  static Future<void> showCustomSnackBar({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,
    Duration delayDuration = errorMessageDisplayDuration,
  }) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }

  /// Retrieves a translated string for the given [labelKey].
  ///
  /// This is a convenience wrapper around the `GetX` translation functionality.
  /// It trims any leading/trailing whitespace from the result.
  ///
  /// - [labelKey]: The key corresponding to the desired translated string.
  /// - Returns: The translated string for the current locale.
  static String getTranslatedLabel(String labelKey) {
    return labelKey.tr.trim();
  }

  /// A shortcut to get the current [ColorScheme] from the context.
  ///
  /// - [context]: The build context from which to access the theme.
  /// - Returns: The application's current [ColorScheme].
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}
