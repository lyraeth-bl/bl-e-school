import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:get/get.dart';

class BudiLuhurRoutes extends BudiLuhur {
  // Auth
  static const String auth = "/auth";
  static const String studentLogin = "/studentLogin";

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
    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
  ];
}
