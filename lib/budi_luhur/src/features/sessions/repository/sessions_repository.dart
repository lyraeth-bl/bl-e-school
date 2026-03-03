import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/model/me_response/me_response.dart';
import 'package:fpdart/fpdart.dart';

abstract class SessionsRepository {
  Future<Result<MeResponse>> fetchMe();

  Future<String?> getAccessToken();

  Future<Unit> setAccessToken(String value);

  Future<Unit> clearSession();
}
