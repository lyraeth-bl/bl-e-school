import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(),
);

const String kAccessTokenKey = "sessions.kAccessToken";
