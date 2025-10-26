import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Initializes the system UI overlay and sets the preferred screen orientation.
///
/// This function configures the appearance of the system status bar and restricts
/// the application to portrait mode.
Future<void> initSystemUIOverlay() async {
  // Set the status bar to be transparent with light icons.
  // This allows the app's content to be displayed behind the status bar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Lock the screen orientation to portrait mode.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
