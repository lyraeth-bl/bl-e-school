import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

abstract class AcademicCalendarRepository {
  Future<Result<MonthlyAcademicResult>> fetchAcademicCalendar({
    required AcademicCalendarRequest academicCalendarRequest,
    bool forceRefresh = false,
  });
}
