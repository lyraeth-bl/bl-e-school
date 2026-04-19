import '../../../utils/shared/types/types.dart';
import '../data/model/daily_attendance/daily_attendance.dart';
import '../data/model/monthly_attendance_result/monthly_attendance_result.dart';

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
