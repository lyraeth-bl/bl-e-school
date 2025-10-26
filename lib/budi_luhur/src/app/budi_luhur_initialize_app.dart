import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/app/init/init_hive_open_box.dart';
import 'package:bl_e_school/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Initializes essential application services and configurations before running the app.
///
/// This function ensures that all necessary setup tasks are completed, including:
/// - Initializing the Flutter binding.
/// - Setting up Firebase services.
/// - Overriding default HTTP behavior for development.
/// - Registering font licenses.
/// - Configuring system UI overlays and screen orientation.
/// - Loading localization (translation) files.
/// - Initializing Hive and open required Box.
/// - Initializing date formatting for the Indonesian locale.
Future<void> budiLuhurInitializeApp() async {
  // Ensure that the Flutter binding is initialized before any Flutter-specific code.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Override the default HttpClient to bypass SSL certificate validation in development.
  HttpOverrides.global = MyHttpOverrides();

  // Register the license for the Google Fonts used in the application.
  await initRegisterGoogleFontsLicences();

  // Set system UI overlay style and restrict screen orientation to portrait mode.
  await initSystemUIOverlay();

  // Load translation files for multi-language support.
  await AppTranslation.loadJsons();

  // Initialize Hive and open required box.
  await initHiveOpenBox();

  // Initialize date formatting for the Indonesian locale ('id_ID').
  await initializeDateFormatting("id_ID", null);

  // Run the main application widget.
  runApp(const BudiLuhurApp());
}
