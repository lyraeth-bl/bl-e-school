import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/model/login_request/login_request.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/model/login_response/login_response.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Result<LoginResponse>> loginSanctum(LoginRequest loginRequest);

  // async {
  //   final data = loginRequest.toJson();
  //
  //   try {
  //     final response = await ApiClient.post(
  //       body: data,
  //       url: ApiEndpoints.loginSanctum,
  //       extra: {"skipAuthInterceptor": true},
  //     );
  //
  //     return Right(LoginResponse.fromJson(response));
  //   } catch (e, st) {
  //     return Left(Failure.fromDio(e, st));
  //   }
  // }

  Future<Unit> logoutSanctum();

  // async {
  //   try {
  //     await ApiClient.post(body: {}, url: ApiEndpoints.logoutSanctum);
  //   } catch (e) {
  //     //
  //   }
  // }

  Future<Unit> closeAndDeleteBox();

  // bool getIsLogIn() {
  //   return Hive.box(authBoxKey).get(isLogInKey) ?? false;
  // }
  //
  // Future<void> setIsLogIn(bool value) async {
  //   return Hive.box(authBoxKey).put(isLogInKey, value);
  // }
  //
  // static bool getIsStudentLogIn() {
  //   return Hive.box(authBoxKey).get(isStudentLogInKey) ?? false;
  // }
  //
  // Future<void> setIsStudentLogIn(bool value) async {
  //   return Hive.box(authBoxKey).put(isStudentLogInKey, value);
  // }
  //
  // static Student getStudentDetails() {
  //   return Student.fromJson(
  //     Map.from(Hive.box(authBoxKey).get(studentDetailsKey) ?? {}),
  //   );
  // }
  //
  // Future<void> setStudentDetails(Student student) async {
  //   return Hive.box(authBoxKey).put(studentDetailsKey, student.toJson());
  // }
  //
  // String getJwtToken() {
  //   return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
  // }
  //
  // Future<void> setJwtToken(String value) async {
  //   return Hive.box(authBoxKey).put(jwtTokenKey, value);
  // }
  //
  // String get schoolCode =>
  //     Hive.box(authBoxKey).get(schoolCodeKey, defaultValue: "") as String;
  //
  // set schoolCode(String value) =>
  //     Hive.box(authBoxKey).put(schoolCodeKey, value);
  //
  // // --- Remote Data Source ---
  //
  // Future<void> signOutUser() async {
  //   final String token = getJwtToken();
  //
  //   if (token.isNotEmpty) {
  //     try {
  //       // Attempt to notify the backend of the logout.
  //       await ApiClient.post(body: {}, url: ApiEndpoints.logout);
  //     } catch (e) {
  //       // Errors are ignored as the local data will be cleared regardless.
  //     }
  //   }
  //
  //   await HydratedBloc.storage.clear();
  //   await closeAndDeleteBox();
  // }
  //
  // Future<Map<String, dynamic>> signInStudent({
  //   required String nis,
  //   required String password,
  // }) async {
  //   try {
  //     final body = {"nis": nis, "password": password};
  //
  //     final response = await ApiClient.post(
  //       body: body,
  //       url: ApiEndpoints.login,
  //       extra: {'skipAuthInterceptor': true},
  //     );
  //
  //     final Map<String, dynamic> studentData = response['siswa'];
  //     final String jwtToken = response['access_token'];
  //
  //     await Future.wait([
  //       setJwtToken(jwtToken),
  //       setStudentDetails(
  //         Student.fromJson(Map<String, dynamic>.from(studentData)),
  //       ),
  //       setIsLogIn(true),
  //       setIsStudentLogIn(true),
  //     ]);
  //
  //     return {
  //       "jwtToken": jwtToken,
  //       "student": Student.fromJson(Map.from(studentData)),
  //       'expiresIn': DateTime.now(),
  //     };
  //   } catch (e) {
  //     throw ApiException(e.toString());
  //   }
  // }
  //
  // Future<RefreshTokenResponse> refreshToken() async {
  //   try {
  //     final response = await ApiClient.post(
  //       body: {},
  //       url: ApiEndpoints.refreshToken,
  //     );
  //
  //     final jwtToken = response['access_token'];
  //
  //     int? expiresIn;
  //
  //     if (response.containsKey('expires_in')) {
  //       final raw = response['expires_in'];
  //
  //       try {
  //         expiresIn = raw is int ? raw : int.tryParse(raw.toString());
  //       } catch (e) {
  //         expiresIn = null;
  //       }
  //     }
  //
  //     await Future.wait([setJwtToken(jwtToken)]);
  //
  //     return RefreshTokenResponse(jwtToken: jwtToken, expiredIn: expiresIn);
  //   } catch (e) {
  //     throw ApiException(e.toString());
  //   }
  // }
}
