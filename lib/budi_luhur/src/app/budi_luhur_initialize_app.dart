import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/app/init/init_google_fonts_licences.dart';
import 'package:bl_e_school/budi_luhur/src/app/init/init_system_overlay.dart';
import 'package:flutter/material.dart';

/// Initializes all the necessary components before running the application.
Future<void> budiLuhurInitializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  /// Registering the licences of [OpenSans](https://fonts.google.com/specimen/Open+Sans) font.
  await initRegisterGoogleFontsLicences();

  /// Override the Theme of user phone status bar and force the orientations.
  await initSystemUIOverlay();

  runApp(const BudiLuhurApp());
}
