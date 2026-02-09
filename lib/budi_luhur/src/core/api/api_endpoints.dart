import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'api_constant.dart';

/// A class that centralizes all the API endpoints used in the application.
///
/// This class provides static access to the full URLs for various API endpoints,
/// making it easy to manage and update them from a single location.
class ApiEndpoints {
  /// Endpoint for user authentication (login).
  static String login = "$databaseUrl/login";

  /// Endpoint for refreshing an expired authentication token.
  static String refreshToken = "$databaseUrl/refresh-token";

  /// Endpoint for user logout.
  static String logout = "$databaseUrl/logout";

  /// Endpoint for accessing student-related data.
  static String siswa = "$databaseUrl/siswa";

  /// Endpoint for managing general attendance records.
  static String absensi = "$databaseUrl/absensi";

  /// Endpoint for managing daily attendance records.
  static String absensiHarian = "$databaseUrl/absensi-harian";

  /// Endpoint for registering and managing device tokens for push notifications.
  static String deviceTokens = "$databaseUrl/device-tokens";

  /// Endpoint for fetching user notifications.
  static String notifications = "$databaseUrl/notifications";

  /// Endpoint for fetching academic calendar.
  static String academicCalendar = "$databaseUrl/kalender-akademik";

  /// Endpoint for sending notifications.
  static String sendNotification = "$databaseUrl/send-notification";

  /// Endpoint for feedback.
  static String feedback = "$databaseUrl/feedback";

  /// Endpoint for appConfig.
  static String appConfiguration = "$databaseUrl/app-config";

  /// Endpoint for fetching timetables.
  static String timeTable = "$databaseInternalUrl/jadwal";

  /// Endpoint for fetching merit.
  static String merit = "$databaseUrl/merit";

  /// Endpoint for fetching demerit.
  static String demerit = "$databaseUrl/demerit";

  /// Endpoint for fetching extracurricular.
  static String extracurricular = "$databaseUrl/ekskul";
}
