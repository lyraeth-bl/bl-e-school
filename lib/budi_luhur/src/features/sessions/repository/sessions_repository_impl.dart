import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../../auth/data/model/student/student.dart';
import '../data/datasources/sessions_local_data_source.dart';
import '../data/datasources/sessions_remote_data_source.dart';
import '../data/model/me_response/me_response.dart';
import 'sessions_repository.dart';

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
  Future<Result<MeResponse>> fetchMe() async {
    final response = await _sessionsRemoteDataSource.fetchMe();

    return response.fold(
      (failure) => Left(failure),
      (meResponse) => Right(meResponse),
    );
  }

  @override
  Future<String?> getAccessToken() async =>
      await _sessionsLocalDataSource.getAccessToken();

  @override
  Future<Unit> setAccessToken(String value) async =>
      await _sessionsLocalDataSource.setAccessToken(value);

  @override
  Future<bool> isLoggedIn() async {
    final token = await _sessionsLocalDataSource.getAccessToken();

    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> getIsStudentLoggedIn() async =>
      _sessionsLocalDataSource.getIsStudentLoggedIn();

  @override
  Student? getLoggedStudentDetails() =>
      _sessionsLocalDataSource.getLoggedStudentDetails();

  @override
  Future<Unit> setIsStudentLoggedIn(bool value) async =>
      _sessionsLocalDataSource.setIsStudentLoggedIn(value);

  @override
  Future<Unit> setLoggedStudentDetails(Student studentDetails) async =>
      _sessionsLocalDataSource.setLoggedStudentDetails(studentDetails);

  @override
  Future<bool> isFirstTimeUserOpenApp() async =>
      _sessionsLocalDataSource.isFirstTimeUserOpenApp();
}
