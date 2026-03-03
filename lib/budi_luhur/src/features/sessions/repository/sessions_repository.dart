import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/model/me_response/me_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

class SessionsRepository {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Future<Result<MeResponse>> me() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.meSanctum);

      return Right(MeResponse.fromJson(response));
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }

  Future<String?> getAccessToken() async =>
      await secureStorage.read(key: kAccessTokenKey);

  Future<void> setAccessToken(String value) async {
    try {
      await secureStorage.write(key: kAccessTokenKey, value: value);
      debugPrint("Success to save accessToken");
    } catch (e) {
      debugPrint("Failed to save accessToken");
    }
  }

  Future<void> clearSession() async {
    await secureStorage.delete(key: kAccessTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }
}
