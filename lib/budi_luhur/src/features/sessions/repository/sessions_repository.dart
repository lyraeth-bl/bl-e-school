import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class SessionsRepository {
  Future<Result<MeResponse>> fetchMe();

  Future<String?> getAccessToken();

  Future<Unit> setAccessToken(String value);

  Future<Unit> clearSession();

  Future<bool> isLoggedIn();

  Future<bool> getIsStudentLoggedIn();

  Future<Unit> setIsStudentLoggedIn(bool value);

  Student getLoggedStudentDetails();

  Future<Unit> setLoggedStudentDetails(Student studentDetails);

  Future<bool> isFirstTimeUserOpenApp();
}
