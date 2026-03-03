import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

abstract class SessionsLocalDataSource {
  Future<String?> getAccessToken();

  Future<Unit> setAccessToken(String value);

  Future<Unit> clearSession();
}

class SessionsLocalDataSourceImpl implements SessionsLocalDataSource {
  /// Menghapus token yang tersimpan di [FlutterSecureStorage];
  @override
  Future<Unit> clearSession() async {
    await secureStorage.delete(key: kAccessTokenKey);

    return unit;
  }

  @override
  Future<String?> getAccessToken() async =>
      await secureStorage.read(key: kAccessTokenKey);

  @override
  Future<Unit> setAccessToken(String value) async {
    try {
      await secureStorage.write(key: kAccessTokenKey, value: value);
      debugPrint("Success to save accessToken");
    } catch (e) {
      debugPrint("Failed to save accessToken");
    }

    return unit;
  }
}
