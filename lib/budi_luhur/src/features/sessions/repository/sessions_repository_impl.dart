import 'package:bl_e_school/budi_luhur/src/features/sessions/data/datasources/sessions_local_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/datasources/sessions_remote_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/model/me_response/me_response.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/repository/sessions_repository.dart';
import 'package:bl_e_school/budi_luhur/src/utils/shared/types/types.dart';
import 'package:fpdart/fpdart.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsLocalDataSource _sessionsLocalDataSource;
  final SessionsRemoteDataSource _sessionsRemoteDataSource;

  SessionsRepositoryImpl(
    this._sessionsRemoteDataSource,
    this._sessionsLocalDataSource,
  );

  @override
  Future<Unit> clearSession() async =>
      await _sessionsLocalDataSource.clearSession();

  @override
  Future<Result<MeResponse>> fetchMe() async =>
      await _sessionsRemoteDataSource.fetchMe();

  @override
  Future<String?> getAccessToken() async =>
      await _sessionsLocalDataSource.getAccessToken();

  @override
  Future<Unit> setAccessToken(String value) async =>
      await _sessionsLocalDataSource.setAccessToken(value);
}
