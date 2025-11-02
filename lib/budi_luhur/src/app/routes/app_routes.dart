import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:get/get.dart';

class BudiLuhurRoutes extends BudiLuhur {
  // Auth
  static const String auth = "/auth";
  static const String authStudent = "/authStudent";

  // Student
  static const String studentOnboarding = "/studentOnboarding";
  static const String studentProfile = "/studentProfile";
  static const String studentAttendance = "/studentAttendance";

  // Splash
  static const String splash = "/splash";

  // Home
  static const String home = "/";

  // getPages
  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
    GetPage(name: authStudent, page: () => AuthStudentScreen.routeInstance()),
    GetPage(
      name: studentOnboarding,
      page: () => StudentOnBoardingScreen.routeInstance(),
    ),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),
    GetPage(
      name: studentAttendance,
      page: () => StudentAttendanceScreen.routeInstance(),
    ),
  ];
}
