import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Initializes all the necessary components before running the application.
Future<void> budiLuhurInitializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HttpOverrides.global = MyHttpOverrides();

  /// Registering the licences of [OpenSans](https://fonts.google.com/specimen/Open+Sans) font.
  await initRegisterGoogleFontsLicences();

  /// Override the Theme of user phone status bar and force the orientations.
  await initSystemUIOverlay();

  /// Initialize Languages.
  await AppTranslation.loadJsons();

  runApp(const BudiLuhurApp());
}
