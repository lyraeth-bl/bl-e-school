import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Initializes Hive for local storage and opens the required boxes.
///
/// This function prepares the Hive database for use by:
/// 1. Initializing Hive with Flutter support.
/// 2. Opening the necessary boxes for the application, including:
///    - [showCaseBoxKey]: For storing data related to the showcase feature.
///    - [authBoxKey]: For caching authentication-related data.
Future<void> initHiveOpenBox() async {
  // Initialize Hive for use in a Flutter application.
  await Hive.initFlutter();

  // Open the boxes required for the application to function correctly.
  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(authBoxKey);
  await Hive.openBox(settingsBoxKey);
}
