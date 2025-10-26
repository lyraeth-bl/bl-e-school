import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

/// Initializes all the necessary components before running the application.
Future<void> budiLuhurInitializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  runApp(const BudiLuhurApp());
}
