import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that defines the application's themes, including light and dark modes.
///
/// This class provides static methods to generate [ThemeData] for both light and dark
/// themes, based on a common seed color. It also configures default properties
/// for various UI components like text and progress indicators.
class BudiLuhurTheme extends BudiLuhur {
  // Default seed color used for generating color schemes.
  static const Color _seedColor = Colors.lightBlueAccent;

  /// Provides access to the default seed color.
  Color get seedColor => _seedColor;

  /// Builds the light theme for the application.
  ///
  /// If a [seedColor] is provided, it will be used to generate the color scheme.
  /// Otherwise, the default [_seedColor] is used.
  static ThemeData lightMode({Color? seedColor}) {
    final seed = seedColor ?? _seedColor;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: GoogleFonts.openSansTextTheme(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeWidth: 5,
        circularTrackColor: colorScheme.secondaryContainer,
      ),
    );
  }

  /// Builds the dark theme for the application.
  ///
  /// If a [seedColor] is provided, it will be used to generate the color scheme.
  /// Otherwise, the default [_seedColor] is used.
  static ThemeData darkMode({Color? seedColor}) {
    final seed = seedColor ?? _seedColor;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.openSansTextTheme(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeWidth: 5,
        circularTrackColor: colorScheme.secondaryContainer,
      ),
    );
  }
}
