import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../../auth/data/model/student/student.dart';
import '../data/model/me_response/me_response.dart';

abstract class SessionsRepository {
  Future<Result<MeResponse>> fetchMe();

  Future<String?> getAccessToken();

  Future<Unit> setAccessToken(String value);

  Future<Unit> clearSession();

  Future<bool> isLoggedIn();

  Future<bool> getIsStudentLoggedIn();

  Future<Unit> setIsStudentLoggedIn(bool value);

  Student? getLoggedStudentDetails();

  Future<Unit> setLoggedStudentDetails(Student studentDetails);

  Future<bool> isFirstTimeUserOpenApp();
}
