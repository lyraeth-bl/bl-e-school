import '../daily_attendance/daily_attendance.dart';

class MonthlyAttendanceResult {
  final List<DailyAttendance> list;
  final DateTime lastUpdated;

  const MonthlyAttendanceResult({
    required this.list,
    required this.lastUpdated,
  });
}
