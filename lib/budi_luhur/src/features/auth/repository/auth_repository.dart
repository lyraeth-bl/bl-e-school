import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive/hive.dart';

/// A repository for managing user authentication, both locally and remotely.
///
/// This class handles storing and retrieving authentication-related data from
/// local storage (Hive) and interacting with the backend for authentication processes
/// like sign-in and sign-out.
class AuthRepository {
  // --- Local Data Source ---

  /// Checks if the user is currently logged in.
  ///
  /// Retrieves the login status from local storage.
  /// Returns `true` if logged in, otherwise `false`.
  bool getIsLogIn() {
    return Hive.box(authBoxKey).get(isLogInKey) ?? false;
  }

  /// Sets the user's login status.
  ///
  /// [value]: The new login status (`true` for logged in, `false` for logged out).
  Future<void> setIsLogIn(bool value) async {
    return Hive.box(authBoxKey).put(isLogInKey, value);
  }

  /// Checks if the logged-in user is a student.
  ///
  /// Retrieves the student login status from local storage.
  /// Returns `true` if the user is a student, otherwise `false`.
  static bool getIsStudentLogIn() {
    return Hive.box(authBoxKey).get(isStudentLogInKey) ?? false;
  }

  /// Sets the student login status.
  ///
  /// [value]: The new student login status.
  Future<void> setIsStudentLogIn(bool value) async {
    return Hive.box(authBoxKey).put(isStudentLogInKey, value);
  }

  /// Retrieves the details of the currently logged-in student.
  ///
  /// Fetches the student data from local storage and deserializes it
  /// into a [Student] object.
  /// Returns a [Student] object, which may be empty if no details are found.
  static Student getStudentDetails() {
    return Student.fromJson(
      Map.from(Hive.box(authBoxKey).get(studentDetailsKey) ?? {}),
    );
  }

  /// Saves the student's details to local storage.
  ///
  /// [student]: The [Student] object to be saved.
  Future<void> setStudentDetails(Student student) async {
    return Hive.box(authBoxKey).put(studentDetailsKey, student.toJson());
  }

  /// Retrieves the JWT authentication token.
  ///
  /// Fetches the token from local storage.
  /// Returns the token string, or an empty string if not found.
  String getJwtToken() {
    return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
  }

  /// Saves the JWT authentication token.
  ///
  /// [value]: The JWT token string to save.
  Future<void> setJwtToken(String value) async {
    return Hive.box(authBoxKey).put(jwtTokenKey, value);
  }

  /// Gets the school code from local storage.
  String get schoolCode =>
      Hive.box(authBoxKey).get(schoolCodeKey, defaultValue: "") as String;

  /// Sets the school code in local storage.
  set schoolCode(String value) =>
      Hive.box(authBoxKey).put(schoolCodeKey, value);

  // --- Remote Data Source ---

  /// Signs out the current user.
  ///
  /// This method sends a request to the logout endpoint to invalidate the session on the server.
  /// It then clears all local authentication and session data, including login status,
  /// JWT token, student details, and any cached attendance data.
  Future<void> signOutUser() async {
    try {
      // Attempt to notify the backend of the logout.
      ApiClient.post(body: {}, url: ApiEndpoints.logout, useAuthToken: true);
    } catch (e) {
      // Errors are ignored as the local data will be cleared regardless.
    }

    // Clear local data
    await Future.wait([
      setIsLogIn(false),
      setIsStudentLogIn(false),
      setJwtToken(""),
      clearStoredStudentData(),
      AttendanceRepository().clearStoredDailyAttendanceData(),
      FeedbackRepository().clearStoredFeedbackData(),
    ]);
  }

  /// Signs in a student with their credentials.
  ///
  /// - [nis]: The student's NIS (Nomor Induk Siswa).
  /// - [password]: The student's password.
  ///
  /// Throws an [ApiException] if the sign-in process fails.
  ///
  /// Returns a `Map<String, dynamic>` upon successful authentication, containing:
  /// - `jwtToken`: The new JWT token.
  /// - `student`: The authenticated [Student] object.
  /// - `expiresIn`: The timestamp of when the authentication occurred.
  Future<Map<String, dynamic>> signInStudent({
    required String nis,
    required String password,
  }) async {
    try {
      final body = {"nis": nis, "password": password};

      final response = await ApiClient.post(
        body: body,
        url: ApiEndpoints.login,
        useAuthToken: false,
      );

      final Map<String, dynamic> studentData = response['siswa'];
      final String jwtToken = response['access_token'];

      await Future.wait([
        setJwtToken(jwtToken),
        setStudentDetails(
          Student.fromJson(Map<String, dynamic>.from(studentData)),
        ),
        setIsLogIn(true),
        setIsStudentLogIn(true),
      ]);

      return {
        "jwtToken": jwtToken,
        "student": Student.fromJson(Map.from(studentData)),
        'expiresIn': DateTime.now(),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Refreshes the authentication token.
  ///
  /// Sends a request to the refresh token endpoint to get a new JWT token.
  /// The new token is then saved to local storage.
  ///
  /// Throws an [ApiException] if the token refresh fails.
  /// Returns a [RefreshTokenResponse] containing the new token and its expiration time.
  Future<RefreshTokenResponse> refreshToken() async {
    try {
      final response = await ApiClient.post(
        body: {},
        url: ApiEndpoints.refreshToken,
        useAuthToken: true,
      );

      final jwtToken = response['access_token'];

      int? expiresIn;

      if (response.containsKey('expires_in')) {
        final raw = response['expires_in'];

        try {
          expiresIn = raw is int ? raw : int.tryParse(raw.toString());
        } catch (e) {
          expiresIn = null;
        }
      }

      await Future.wait([setJwtToken(jwtToken)]);

      return RefreshTokenResponse(jwtToken: jwtToken, expiredIn: expiresIn);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> clearStoredStudentData() {
    print("clearing Student Data");
    return Hive.box(authBoxKey).clear().then((_) {
      print("Student data cleared");
    });
  }
}
