import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionsLocalDataSource {
  Future<String?> getAccessToken();

  Future<Unit> setAccessToken(String value);

  Future<Unit> clearSession();

  Future<bool> getIsStudentLoggedIn();

  Future<Unit> setIsStudentLoggedIn(bool value);

  Student? getLoggedStudentDetails();

  Future<Unit> setLoggedStudentDetails(Student studentDetails);

  Future<bool> isFirstTimeUserOpenApp();
}

class SessionsLocalDataSourceImpl implements SessionsLocalDataSource {
  final SharedPreferences prefs = sI<SharedPreferences>();

  /// Menghapus token yang tersimpan di [FlutterSecureStorage];
  @override
  Future<Unit> clearSession() async {
    await secureStorage.delete(key: kAccessTokenKey);
    debugPrint("await secureStorage.delete(key: kAccessTokenKey) success");

    await Hive.box(sessionsBoxKey).clear();
    debugPrint("await Hive.box(sessionsBoxKey).clear() success");

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

  @override
  Future<bool> getIsStudentLoggedIn() async =>
      prefs.getBool(kSessionsIsStudentLoggedInKey) ?? false;

  @override
  Student? getLoggedStudentDetails() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsLoggedStudentDetailKey);

    if (raw == null) return null;

    return Student.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<Unit> setIsStudentLoggedIn(bool value) async {
    await prefs.setBool(kSessionsIsStudentLoggedInKey, value);

    return unit;
  }

  @override
  Future<Unit> setLoggedStudentDetails(Student studentDetails) async {
    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsLoggedStudentDetailKey, studentDetails.toJson());

    return unit;
  }

  @override
  Future<bool> isFirstTimeUserOpenApp() async {
    return prefs.getBool(kSessionIsFirstTimeUserOpenAppKey) ?? true;
  }
}
