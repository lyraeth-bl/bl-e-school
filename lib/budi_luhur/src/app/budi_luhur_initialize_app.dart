import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
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
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }

  // Register the license for the Google Fonts used in the application.
  await initRegisterGoogleFontsLicences();

  // Set system UI overlay style and restrict screen orientation to portrait mode.
  await initSystemUIOverlay();

  // Load translation files for multi-language support.
  await AppTranslation.loadJsons();

  // Initialize Hive and open required box.
  await initHiveOpenBox();

  // Initialize notifications.
  if (!kIsWeb) {
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
  }

  // Initialize date formatting for the Indonesian locale ('id_ID').
  await initializeDateFormatting("id", null);

  await initDI();

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  final sessionsBloc = sI<SessionsBloc>();

  dio.interceptors.add(
    AuthInterceptor(
      sessionsBloc: sessionsBloc,
      sessionsRepository: sI<SessionsRepository>(),
    ),
  );

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

  // App Bloc Observer
  Bloc.observer = const AppBlocObserver();

  // Run the main application widget.
  runApp(BudiLuhurApp());
}
