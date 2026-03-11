import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudiLuhurTheme extends BudiLuhur {
  static const Color _seedColor = Colors.blue;

  Color get seedColor => _seedColor;

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
      textTheme: GoogleFonts.poppinsTextTheme(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeWidth: 5,
        circularTrackColor: colorScheme.secondaryContainer,
      ),
    );
  }

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
      textTheme: GoogleFonts.poppinsTextTheme(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeWidth: 5,
        circularTrackColor: colorScheme.secondaryContainer,
      ),
    );
  }
}
