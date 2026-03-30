import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:get/get.dart';

class BudiLuhurRoutes extends BudiLuhur {
  static const String auth = "/auth";

  static const String authStudent = "/authStudent";

  static const String studentOnboarding = "/studentOnboarding";

  static const String studentProfile = "/studentProfile";

  static const String studentDetailsProfile = "/studentDetailsProfile";

  static const String studentAttendance = "/studentAttendance";

  static const String studentTimeTable = "/studentTimeTable";

  static const String studentFeedback = "/studentFeedback";

  static const String studentAddFeedback = "/studentAddFeedback";

  static const String studentResult = "/studentResult";

  static const String splash = "/splash";

  static const String home = "/";

  static const String notifications = "/notifications";

  static const String academicCalendar = "/academicCalendar";

  static const String settings = "/settings";

  static const String contactUs = "/contactUs";

  static const String aboutUs = "/aboutUs";

  static const String diagnosis = "/diagnosis";

  static const String diagnosisPushNotification = "/diagnosisPushNotification";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),

    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
    GetPage(name: authStudent, page: () => AuthStudentScreen.routeInstance()),

    GetPage(
      name: studentOnboarding,
      page: () => StudentOnBoardingScreen.routeInstance(),
    ),

    GetPage(
      name: studentAttendance,
      page: () => StudentAttendanceScreen.routeInstance(),
    ),
    GetPage(
      name: studentTimeTable,
      page: () => StudentTimeTableScreen.routeInstance(),
    ),
    GetPage(
      name: studentProfile,
      page: () => StudentProfileScreen.routeInstance(),
    ),
    GetPage(
      name: studentDetailsProfile,
      page: () => StudentDetailsStudentScreen.routeInstance(),
    ),

    GetPage(name: studentFeedback, page: () => FeedbackScreen.routeInstance()),

    GetPage(
      name: studentAddFeedback,
      page: () => AddFeedbackScreen.routeInstance(),
    ),

    GetPage(name: studentResult, page: AcademicResultScreen.routeInstance),

    GetPage(
      name: notifications,
      page: () => NotificationsScreen.routeInstance(),
    ),
    GetPage(
      name: academicCalendar,
      page: () => AcademicCalendarScreen.routeInstance(),
    ),
    GetPage(name: settings, page: () => SettingsScreen.routeInstance()),
    GetPage(name: contactUs, page: () => ContactUsScreen.routeInstance()),
    GetPage(name: aboutUs, page: () => AboutUsScreen.routeInstance()),
    GetPage(name: diagnosis, page: () => DiagnosisScreen.routeInstance()),
    GetPage(
      name: diagnosisPushNotification,
      page: () => DiagnosisPushNotificationScreen.routeInstance(),
    ),
  ];
}
