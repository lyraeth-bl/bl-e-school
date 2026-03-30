import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initDI() async {
  await initPrefsDI();
  await initSessionsDI();
  await initAuthDI();
  await initDeviceTokenDI();
  await initAppConfigDI();
  await initTimeTableDI();
  await initDisciplineDI();
  await initExtracurricularDI();
  await initFeedbackDI();
  await initDailyAttendanceDI();
  await initAcademicCalendarDI();
  await initAcademicResultDI();
}
