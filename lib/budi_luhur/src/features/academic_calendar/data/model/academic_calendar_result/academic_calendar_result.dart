import '../academic_calendar/academic_calendar.dart';

class MonthlyAcademicResult {
  final List<AcademicCalendar> list;
  final DateTime lastUpdated;

  const MonthlyAcademicResult({required this.list, required this.lastUpdated});
}
