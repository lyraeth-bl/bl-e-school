import '../../core/storage/prefs_storage/prefs_di.dart';
import '../../features/academic_calendar/academic_calendar_di.dart';
import '../../features/academic_result/academic_result_di.dart';
import '../../features/app_config/app_config_di.dart';
import '../../features/auth/auth_di.dart';
import '../../features/daily_attendance/daily_attendance_di.dart';
import '../../features/device_tokens/device_token_di.dart';
import '../../features/discipline/discipline_di.dart';
import '../../features/extracurricular/extracurricular_di.dart';
import '../../features/feedback/feedback_di.dart';
import '../../features/sessions/sessions_di.dart';
import '../../features/time_table/time_table_di.dart';

void initDI() {
  initPrefsDI();
  initSessionsDI();
  initAuthDI();
  initDeviceTokenDI();
  initAppConfigDI();
  initTimeTableDI();
  initDisciplineDI();
  initExtracurricularDI();
  initFeedbackDI();
  initDailyAttendanceDI();
  initAcademicCalendarDI();
  initAcademicResultDI();
}
