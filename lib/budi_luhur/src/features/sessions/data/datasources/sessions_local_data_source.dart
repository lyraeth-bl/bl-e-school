import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/core/storage/prefs_storage/prefs_storage_label.dart';
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

  Student getLoggedStudentDetails();

  Future<Unit> setLoggedStudentDetails(Student studentDetails);
}

class SessionsLocalDataSourceImpl implements SessionsLocalDataSource {
  final SharedPreferences prefs = sI<SharedPreferences>();

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

  @override
  Future<bool> getIsStudentLoggedIn() async =>
      prefs.getBool(kSessionsIsStudentLoggedInKey) ?? false;

  @override
  Student getLoggedStudentDetails() => Student.fromJson(
    Map<String, dynamic>.from(
      Hive.box(authBoxKey).get(studentDetailsKey) ?? {},
    ),
  );

  @override
  Future<Unit> setIsStudentLoggedIn(bool value) async {
    await prefs.setBool(kSessionsIsStudentLoggedInKey, value);

    return unit;
  }

  @override
  Future<Unit> setLoggedStudentDetails(Student studentDetails) async {
    Hive.box(authBoxKey).put(studentDetailsKey, studentDetails.toJson());

    return unit;
  }
}
