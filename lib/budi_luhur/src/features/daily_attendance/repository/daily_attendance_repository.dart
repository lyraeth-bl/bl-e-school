import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

abstract class DailyAttendanceRepository {
  Future<Result<DailyAttendance>> fetchTodayAttendance({
    bool forceRefresh = false,
  });

  Future<Result<MonthlyAttendanceResult>> fetchMonthlyAttendance({
    required int year,
    required int month,
    bool forceRefresh = false,
  });
}
