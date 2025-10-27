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
  /// This method sends a request to the logout endpoint and clears all
  /// local authentication data, including login status, JWT token, and student details.
  Future<void> signOutUser() async {
    try {
      // Attempt to notify the backend of the logout.
      ApiClient.post(body: {}, url: ApiEndpoints.logout, useAuthToken: true);
    } catch (e) {
      // Errors are ignored as the local data will be cleared regardless.
    }

    // Clear local session data.
    setIsLogIn(false);
    setJwtToken("");
    setStudentDetails(Student.fromJson({}));
  }

  /// Signs in a student with their credentials.
  ///
  /// - [nis]: The student's NIS (Nomor Induk Siswa).
  /// - [password]: The student's password.
  ///
  /// Throws an [ApiException] if the sign-in process fails.
  /// Returns a `Map<String, dynamic>` containing the JWT token, its expiration,
  /// and the student's details upon successful authentication.
  Future<Map<String, dynamic>> signInStudent({
    required String nis,
    required String password,
  }) async {
    try {
      final body = {"nis": nis, "password": password};

      final result = await ApiClient.post(
        body: body,
        url: ApiEndpoints.login,
        useAuthToken: false,
      );

      final Map<String, dynamic> studentData = result['siswa'];
      final String jwtToken = result['access_token'];
      final int jwtTokenExpiresIn = result['expires_in'];
      final String studentUnit = result['siswa']['unit'].toLowerCase();

      return {
        "jwtToken": jwtToken,
        "jwtTokenExpiresIn": jwtTokenExpiresIn,
        "unit": studentUnit,
        "student": Student.fromJson(Map.from(studentData)),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
