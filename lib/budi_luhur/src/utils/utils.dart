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

/// A utility class containing static helper methods and constants for common tasks.
///
/// This class provides a collection of convenient functions and properties that can be used
/// throughout the application, such as locale conversion, displaying custom snack bars,
/// accessing theme properties, and providing standardized dimensions for UI elements.
class Utils {
  // --- UI Sizing and Padding ---

  /// Top padding for main screen content.
  static double screenContentTopPadding = 15.0;

  /// Horizontal padding for main screen content.
  static double screenContentHorizontalPadding = 25.0;

  /// Font size for main screen titles.
  static double screenTitleFontSize = 18.0;

  /// Font size for onboarding screen titles.
  static double screenOnboardingTitleFontSize = 25.0;

  /// Horizontal padding for screen content as a percentage of screen width.
  static double screenContentHorizontalPaddingInPercentage = 0.075;

  /// Font size for screen subtitles.
  static double screenSubTitleFontSize = 14.0;

  /// Extra top padding for scrolling content to avoid overlap with headers.
  static double extraScreenContentTopPaddingForScrolling = 0.0275;

  // --- AppBar Dimensions ---

  /// Height percentage for a smaller app bar.
  static double appBarSmallerHeightPercentage = 0.15;

  /// Height percentage for a medium-sized app bar.
  static double appBarMediumHeightPercentage = 0.18;

  /// Height percentage for a larger app bar.
  static double appBarBiggerHeightPercentage = 0.215;

  /// Top padding for content within the app bar.
  static double appBarContentTopPadding = 25.0;

  // --- Bottom Navigation and Bottom Sheet ---

  /// Height percentage for the bottom navigation bar.
  static double bottomNavigationHeightPercentage = 0.08;

  /// Bottom margin for the bottom navigation bar.
  static double bottomNavigationBottomMargin = 25;

  /// Top radius for bottom sheets to create rounded corners.
  static double bottomSheetTopRadius = 20.0;

  // --- Miscellaneous UI Constants ---

  /// Font size for the first letter of a subject name, often used for avatars.
  static double subjectFirstLetterFontSize = 20;

  /// Default height and width percentage for profile pictures.
  static double defaultProfilePictureHeightAndWidthPercentage = 0.175;

  /// Height percentage for the container holding a question.
  static double questionContainerHeightPercentage = 0.725;

  // --- Animation Durations and Curves ---

  /// Animation duration for the tab background container.
  static Duration tabBackgroundContainerAnimationDuration = const Duration(
    milliseconds: 300,
  );

  /// Delay before displaying a show-case (feature discovery) element.
  static Duration showCaseDisplayDelayInDuration = const Duration(
    milliseconds: 350,
  );

  /// Animation curve for the tab background container.
  static Curve tabBackgroundContainerAnimationCurve = Curves.easeInOut;

  // --- Shimmer Loading Placeholders ---

  /// Default height for shimmer loading placeholder containers.
  static double shimmerLoadingContainerDefaultHeight = 7;

  /// Default number of content items to display in a shimmer loading animation.
  static int defaultShimmerLoadingContentCount = 6;

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

  /// Displays a custom overlay message (similar to a snack bar).
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

  /// Calculates the top padding for a scrollable view.
  ///
  /// This is used to position content below an app bar, preventing overlap.
  ///
  /// - [context]: The build context to get media query information.
  /// - [appBarHeightPercentage]: The height of the app bar as a percentage of the screen height.
  /// - Returns: The calculated top padding value.
  static double getScrollViewTopPadding({
    required BuildContext context,
    required double appBarHeightPercentage,
  }) {
    return MediaQuery.of(context).size.height *
        (appBarHeightPercentage + extraScreenContentTopPaddingForScrolling);
  }

  /// Calculates the bottom padding for a scrollable view.
  ///
  /// This is used to ensure that content at the bottom of a scrollable list
  /// is not obscured by the bottom navigation bar.
  ///
  /// - [context]: The build context to get media query information.
  /// - Returns: The calculated bottom padding value.
  static double getScrollViewBottomPadding(BuildContext context) {
    return MediaQuery.of(context).size.height *
            (Utils.bottomNavigationHeightPercentage) +
        Utils.bottomNavigationBottomMargin * (1.5);
  }
}
