import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A Method to override the SystemUI and orientations.
Future<void> initSystemUIOverlay() async {
  /// A Settings for override the theme of user phone status bar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  /// A Setting for app orientations only Portrait.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
