part of 'api_client.dart';

class ApiEndpoints {
  static String loginSanctum = "$sanctumUrl/login";

  static String logoutSanctum = "$sanctumUrl/logout";

  static String meSanctum = "$sanctumUrl/me";

  static String attendanceSanctum = "$sanctumUrl/absensi-harian";

  static String deviceTokensSanctum = "$sanctumUrl/device-tokens";

  static String academicCalendarSanctum = "$sanctumUrl/kalender-akademik";

  static String sendNotificationSanctum = "$sanctumUrl/send-notification";

  static String feedbackSanctum = "$sanctumUrl/feedback";

  static String appConfigSanctum = "$sanctumUrl/app-config";

  static String timeTable = "$databaseInternalUrl/jadwal";

  static String meritSanctum = "$sanctumUrl/merit";

  static String demeritSanctum = "$sanctumUrl/demerit";

  static String extracurricularSanctum = "$sanctumUrl/ekskul";

  static String resultSanctum = "$sanctumUrl/nilai";
}
