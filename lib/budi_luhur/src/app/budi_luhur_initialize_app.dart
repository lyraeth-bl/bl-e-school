import 'dart:io';

import 'package:bl_e_school/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/api/api_client.dart';
import '../core/authentication/auth_interceptor/auth_interceptor.dart';
import '../core/dependencies_injection/get_it_instance.dart';
import '../core/http_overrides/my_http_overrides.dart';
import '../features/features.dart';
import 'app_bloc_observer.dart';
import 'budi_luhur_app.dart';
import 'init/init_dependencies_injection.dart';
import 'init/init_google_fonts_licences.dart';
import 'init/init_hive_open_box.dart';
import 'init/init_languages.dart';
import 'init/init_system_overlay.dart';

Future<void> budiLuhurInitializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }

  initRegisterGoogleFontsLicences();
  initSystemUIOverlay();
  AppTranslation.loadJsons();
  await initHiveOpenBox();
  initializeDateFormatting("id", null);
  initDI();

  if (!kIsWeb) {
    await DownloadNotificationService.initChannels();
  }

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      sessionsBloc: sI<SessionsBloc>(),
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

  Bloc.observer = const AppBlocObserver();

  runApp(BudiLuhurApp());
}
