import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:get/get.dart';

/// A class that holds the application's routes and their bindings.
///
/// This class defines all the navigation routes as static constants and provides a
/// `getPages` list that maps these routes to their corresponding screen widgets.
/// This setup is used by the `GetX` package to manage navigation.
class BudiLuhurRoutes extends BudiLuhur {
  // --- Authentication Routes ---

  /// The route for the main authentication screen (e.g., for parents/staff).
  /// Navigates to [AuthScreen].
  static const String auth = "/auth";

  /// The route for the student-specific authentication screen.
  /// Navigates to [AuthStudentScreen].
  static const String authStudent = "/authStudent";

  // --- Student-Specific Routes ---

  /// The route for the student onboarding process, shown after initial login.
  /// Navigates to [StudentOnBoardingScreen].
  static const String studentOnboarding = "/studentOnboarding";

  /// The route to the student's main profile page.
  /// Navigates to [StudentProfileScreen].
  static const String studentProfile = "/studentProfile";

  /// The route to the student's detailed profile information page.
  /// Navigates to [StudentDetailsStudentScreen].
  static const String studentDetailsProfile = "/studentDetailsProfile";

  /// The route to the student's attendance tracking page.
  /// Navigates to [StudentAttendanceScreen].
  static const String studentAttendance = "/studentAttendance";

  /// The route to the student's class timetable or schedule.
  /// Navigates to [StudentTimeTableScreen].
  static const String studentTimeTable = "/studentTimeTable";

  /// The route for accessing feedback screen.
  /// Navigates to [FeedbackScreen].
  static const String studentFeedback = "/studentFeedback";

  /// The route to the student's class timetable or schedule.
  /// Navigates to [StudentTimeTableScreen].
  static const String studentAddFeedback = "/studentAddFeedback";

  // --- Core Application Routes ---

  /// The route for the splash screen, displayed briefly on app startup.
  /// Navigates to [SplashScreen].
  static const String splash = "/splash";

  /// The main home screen route, serving as the default screen after login.
  /// Navigates to [HomeScreen].
  static const String home = "/";

  /// The route for displaying user notifications.
  /// Navigates to [NotificationsScreen].
  static const String notifications = "/notifications";

  /// The route for viewing the academic calendar.
  /// Navigates to [AcademicCalendarScreen].
  static const String academicCalendar = "/academicCalendar";

  /// The route for accessing application settings.
  /// Navigates to [SettingsScreen].
  static const String settings = "/settings";

  /// A list of [GetPage] objects that defines the application's route table.
  ///
  /// Each [GetPage] entry maps a route name to a page-building function (`page`),
  /// allowing for named navigation throughout the app using `Get.toNamed()`.
  /// The `routeInstance()` method on each screen is used to handle dependency
  /// injection and provide a properly configured widget instance.
  static List<GetPage> getPages = [
    // -- Core Application Routes --
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),

    // -- Authentication Routes --
    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
    GetPage(name: authStudent, page: () => AuthStudentScreen.routeInstance()),

    // -- Onboarding Route --
    GetPage(
      name: studentOnboarding,
      page: () => StudentOnBoardingScreen.routeInstance(),
    ),

    // -- Student Feature Routes --
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

    // -- Other Feature Routes --
    GetPage(
      name: notifications,
      page: () => NotificationsScreen.routeInstance(),
    ),
    GetPage(
      name: academicCalendar,
      page: () => AcademicCalendarScreen.routeInstance(),
    ),
    GetPage(name: settings, page: () => SettingsScreen.routeInstance()),
    GetPage(name: studentFeedback, page: () => FeedbackScreen.routeInstance()),
    GetPage(
      name: studentAddFeedback,
      page: () => AddFeedbackScreen.routeInstance(),
    ),
  ];
}
