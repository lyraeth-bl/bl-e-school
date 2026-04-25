import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/datasources/academic_calendar_local_data_source.dart';
import '../data/datasources/academic_calendar_remote_data_source.dart';
import '../data/model/academic_calendar_request/academic_calendar_request.dart';
import '../data/model/academic_calendar_result/academic_calendar_result.dart';
import 'academic_calendar_repository.dart';

class AcademicCalendarRepositoryImpl implements AcademicCalendarRepository {
  final AcademicCalendarLocalDataSource _localDataSource;
  final AcademicCalendarRemoteDataSource _remoteDataSource;

  AcademicCalendarRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<MonthlyAcademicResult>> fetchAcademicCalendar({
    required AcademicCalendarRequest academicCalendarRequest,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _localDataSource.getStoredMonthlyAcademic(
        year: academicCalendarRequest.year,
        month: academicCalendarRequest.month,
      );
      final lastUpdated = _localDataSource.getMonthlyLastUpdated();
      if (cached != null && lastUpdated != null) {
        return Right(
          MonthlyAcademicResult(list: cached, lastUpdated: lastUpdated),
        );
      }
    }

    final result = await _remoteDataSource.fetchMonthlyAcademic(
      academicCalendarRequest: AcademicCalendarRequest(
        year: academicCalendarRequest.year,
        month: academicCalendarRequest.month,
        unit: academicCalendarRequest.unit,
      ),
    );

    return result.match((failure) => Left(failure), (response) async {
      final list = response.listAcademicCalendar;
      final now = DateTime.now();
      await _localDataSource.saveStoredMonthlyAcademic(
        list,
        year: academicCalendarRequest.year,
        month: academicCalendarRequest.month,
      );
      await _localDataSource.saveMonthlyLastUpdated(now);
      return Right(MonthlyAcademicResult(list: list, lastUpdated: now));
    });
  }
}
