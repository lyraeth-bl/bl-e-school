library;

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  /// Formats a [DateTime] object into a "dd-MM-yyyy" string.
  ///
  /// Example: `22-09-2025`
  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  /// Formats a [DateTime] into a "dd MMM yy" string.
  ///
  /// Example: `22 Sep 25`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatDateTwo(DateTime date, {String? locale}) {
    return DateFormat("dd MMM yy", locale).format(date);
  }

  /// Formats a [DateTime] into a "dd MMMM yyyy" string.
  ///
  /// Example: `22 September 2025`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatToDayMonthYear(DateTime date, {String? locale}) {
    return DateFormat("dd MMMM yyyy", locale).format(date);
  }

  static String formatFromDateToDate(
    DateTime fromDate,
    DateTime toDate, {
    String? locale,
  }) {
    return "${formatToDayMonthYear(fromDate)} - ${formatToDayMonthYear(toDate)}";
  }

  /// Formats a [DateTime] into a "MMMM yyyy" string.
  ///
  /// Example: `September 2025`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatToMonthYear(DateTime date, {String? locale}) {
    return DateFormat("MMMM yyyy", locale).format(date);
  }

  /// Formats a [DateTime] into a "HH : mm : ss" string (24-hour clock).
  ///
  /// Example: `12 : 00 : 00`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatClock(DateTime date, {String? locale}) {
    return DateFormat("HH : mm : ss", locale).format(date);
  }

  /// Formats a [DateTime] into a "HH : mm" string (24-hour clock).
  ///
  /// Example: `12 : 00`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatTime(DateTime date, {String? locale}) {
    return DateFormat("HH : mm", locale).format(date);
  }

  /// Formats a [DateTime] into a "EEEE, dd MMM yyyy" string.
  ///
  /// Example: `Monday, 22 Sep 2025`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatDay(DateTime date, {String? locale}) {
    return DateFormat("EEEE, dd MMM yyyy", locale).format(date);
  }

  /// Formats a [DateTime] into a "EEEE, dd MMMM yyyy" string.
  ///
  /// Example: `Monday, 22 September 2025`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatDays(DateTime date, {String? locale}) {
    return DateFormat("EEEE, dd MMMM yyyy", locale).format(date);
  }

  /// Formats a [DateTime] into a "EEEE, dd MMM yyyy, HH : mm" string.
  ///
  /// Example: `Monday, 22 Sep 2025, 12 : 00`
  ///
  /// - [date]: The date to format.
  /// - [locale]: The locale to use for formatting. Defaults to the current system locale if `null`.
  static String formatDaysAndTime(DateTime date, {String? locale}) {
    return DateFormat("EEEE, dd MMM yyyy, HH : mm", locale).format(date);
  }

  /// Converts a time string in "H:mm" format to a [DateTime] object for the current day.
  ///
  /// This function takes a string representing a time (e.g., "07:00" or "14:30") and
  /// combines it with the current date (year, month, day) to create a full [DateTime] object.
  ///
  /// Example:
  /// If today is 2023-10-27 and `hhmm` is "15:45", the function will return
  /// a `DateTime` object representing October 27, 2023, at 3:45 PM.
  ///
  /// - [hhmm]: The time string to parse, in "H:mm" format. Can be null.
  /// - Returns: A [DateTime] object representing the parsed time on today's date,
  ///   or `null` if the input string is null or cannot be parsed.
  static DateTime? timeStringToToday(String? hhmm) {
    if (hhmm == null) return null;
    try {
      final fmt = DateFormat('H:mm');
      final time = fmt.parse(hhmm);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  /// Determines the appropriate back button icon path based on the text directionality.
  ///
  /// This is used to support both Left-to-Right (LTR) and Right-to-Left (RTL) layouts.
  ///
  /// - [context]: The build context to get the current [TextDirection].
  /// - Returns: The asset path for the correct back button icon.
  static String getBackButtonPath(BuildContext context) {
    return Directionality.of(context).name == TextDirection.RTL.value
        ? ("assets/images/rtl_back_icon.svg")
        : ("assets/images/back_icon.svg");
  }

  /// Retrieves a localized error message corresponding to a given error code.
  ///
  /// This function maps an error code to a message key and then uses the
  /// localization system to get the translated error message.
  ///
  /// - [context]: The build context (currently unused but good practice to keep for future needs).
  /// - [errorCode]: The error code to look up.
  /// - Returns: The translated, user-friendly error message.
  static String getErrorMessageFromErrorCode(
    BuildContext context,
    String errorCode,
  ) {
    return Utils.getTranslatedLabel(
      ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(errorCode),
    );
  }

  /// A list of keys for the days of the week, used for localization.
  static final List<String> weekDays = [
    mondayKey,
    tuesdayKey,
    wednesdayKey,
    thursdayKey,
    fridayKey,
    saturdayKey,
    sundayKey,
  ];

  /// A list of the full names of the days of the week in English.
  static final List<String> weekDaysFullForm = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  /// A list of the full names of the days of the week in Indonesian.
  static final List<String> weekDaysFullFormTranslated = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  static final List<String> months = [
    januaryKey,
    februaryKey,
    marchKey,
    aprilKey,
    mayKey,
    juneKey,
    julyKey,
    augustKey,
    septemberKey,
    octoberKey,
    novemberKey,
    decemberKey,
  ];

  /// Formats an empty string to a hyphen, otherwise returns the original string.
  ///
  /// This is a simple helper function to ensure that empty data fields are
  /// displayed with a placeholder ("-") in the UI, improving readability.
  ///
  /// - [value]: The input string to format.
  /// - Returns: A hyphen ("-") if the input string is empty, otherwise the
  ///   original string.
  static String formatEmptyValue(String value) {
    return value.isEmpty ? "-" : value;
  }

  static String getMonthName(int monthNumber) {
    return months[monthNumber - 1];
  }

  static IconData iconForReligion(String religion) {
    switch (religion) {
      case "islam":
        return Icons.mosque;
      case "kristen":
        return Icons.church;
      case "katolik":
        return Icons.church;
      case "protestan":
        return Icons.church;
      case "budha":
        return Icons.self_improvement;
      case "hindu":
        return Icons.temple_hindu;
      default:
        return Icons.help_outline;
    }
  }

  static String formatNumberDaysToStringDays(int days) {
    switch (days) {
      case 1:
        return "senin";
      case 2:
        return "selasa";
      case 3:
        return "rabu";
      case 4:
        return "kamis";
      case 5:
        return "jumat";
      case 6:
        return "sabtu";
      default:
        return "minggu";
    }
  }

  static String getPeriodString(String periodString) {
    switch (periodString) {
      case "1st period":
        return getTranslatedLabel(firstPeriodKey);
      case "2nd period":
        return getTranslatedLabel(secondPeriodKey);
      case "3rd period":
        return getTranslatedLabel(thirdPeriodKey);
      case "4th period":
        return getTranslatedLabel(fourthPeriodKey);
      case "5th period":
        return getTranslatedLabel(fifthPeriodKey);
      case "6th period":
        return getTranslatedLabel(sixPeriodKey);
      case "7th period":
        return getTranslatedLabel(sevenPeriodKey);
      case "8th period":
        return getTranslatedLabel(eightPeriodKey);
      case "9th period":
        return getTranslatedLabel(ninePeriodKey);
      case "10th period":
        return getTranslatedLabel(tenPeriodKey);
      default:
        return getTranslatedLabel(breakKey);
    }
  }
}
