import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class MonthlyAttendanceResult {
  final List<DailyAttendance> list;
  final DateTime lastUpdated;

  const MonthlyAttendanceResult({
    required this.list,
    required this.lastUpdated,
  });
}
