import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/app/init/init_hive_open_box.dart';
import 'package:bl_e_school/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Initializes essential application services and configurations before running the app.
///
/// This function ensures that all necessary setup tasks are completed, including:
/// - Initializing the Flutter binding.
/// - Load .env file
/// - Initializing the HydratedBloc Storage.
/// - Setting up Firebase services.
/// - Overriding default HTTP behavior for development.
/// - Registering font licenses.
/// - Configuring system UI overlays and screen orientation.
/// - Loading localization (translation) files.
/// - Initializing notifications.
/// - Initializing Hive and open required Box.
/// - Initializing date formatting for the Indonesian locale.
Future<void> budiLuhurInitializeApp() async {
  // Ensure that the Flutter binding is initialized before any Flutter-specific code.
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize HydratedBloc.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

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

  // Initialize notifications.
  await NotificationsUtility.initializeAwesomeNotification();

  await NotificationsUtility.setUpNotificationService();

  FirebaseMessaging.onMessage.listen(
    NotificationsUtility.foregroundMessageListener,
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationsUtility.onActionReceivedMethod,
    onNotificationCreatedMethod:
        NotificationsUtility.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationsUtility.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationsUtility.onDismissActionReceivedMethod,
  );

  // Initialize date formatting for the Indonesian locale ('id_ID').
  await initializeDateFormatting("id", null);

  final authCubit = AuthCubit(
    AuthRepository(),
    BiometricAuth("Please authenticate"),
  );

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(AuthInterceptor(dio: dio, authCubit: authCubit));

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  ApiClient.init(dioInstance: dio);

  // Run the main application widget.
  runApp(BudiLuhurApp(authCubit: authCubit));
}
