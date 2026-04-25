import '../../../utils/shared/types/types.dart';
import '../data/model/academic_calendar_request/academic_calendar_request.dart';
import '../data/model/academic_calendar_result/academic_calendar_result.dart';

abstract class AcademicCalendarRepository {
  Future<Result<MonthlyAcademicResult>> fetchAcademicCalendar({
    required AcademicCalendarRequest academicCalendarRequest,
    bool forceRefresh = false,
  });
}
