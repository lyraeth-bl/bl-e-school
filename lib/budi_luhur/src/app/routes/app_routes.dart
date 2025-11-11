import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/profile/screen/student_details_student_screen.dart';
import 'package:get/get.dart';

/// A class that holds the application's routes and their bindings.
///
/// This class defines all the navigation routes as static constants and provides a
/// `getPages` list that maps these routes to their corresponding screen widgets.
/// This setup is used by the `GetX` package to manage navigation.
class BudiLuhurRoutes extends BudiLuhur {
  // --- Authentication Routes ---

  /// The route for the main authentication screen (e.g., for parents/staff).
  static const String auth = "/auth";

  /// The route for the student-specific authentication screen.
  static const String authStudent = "/authStudent";

  // --- Student-Specific Routes ---

  /// The route for the student onboarding process.
  static const String studentOnboarding = "/studentOnboarding";

  /// The route to the student's profile page.
  static const String studentProfile = "/studentProfile";

  /// The route to the student's details profile page.
  static const String studentDetailsProfile = "/studentDetailsProfile";

  /// The route to the student's attendance tracking page.
  static const String studentAttendance = "/studentAttendance";

  /// The route to the student's class timetable.
  static const String studentTimeTable = "/studentTimeTable";

  // --- Core Application Routes ---

  /// The route for the splash screen, shown on app startup.
  static const String splash = "/splash";

  /// The main home screen route, typically the default screen after login.
  static const String home = "/";

  static const String notifications = "/notifications";

  static const String academicCalendar = "/academicCalendar";

  /// A list of [GetPage] objects that defines the application's route table.
  ///
  /// Each [GetPage] entry maps a route name to a page-building function,
  /// allowing for named navigation throughout the app using `Get.toNamed()`.
  static List<GetPage> getPages = [
    // Splash screen route
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),

    // Authentication routes
    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
    GetPage(name: authStudent, page: () => AuthStudentScreen.routeInstance()),

    // Onboarding route
    GetPage(
      name: studentOnboarding,
      page: () => StudentOnBoardingScreen.routeInstance(),
    ),

    // Main home screen route
    GetPage(name: home, page: () => HomeScreen.routeInstance()),

    // Student feature routes
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

    // Notifications route
    GetPage(
      name: notifications,
      page: () => NotificationsScreen.routeInstance(),
    ),

    // Academic Calendar route
    GetPage(
      name: academicCalendar,
      page: () => AcademicCalendarScreen.routeInstance(),
    ),
  ];
}
