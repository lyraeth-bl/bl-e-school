import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class DailyAttendanceRepositoryImpl implements DailyAttendanceRepository {
  final DailyAttendanceLocalDataSource _localDataSource;
  final DailyAttendanceRemoteDataSource _remoteDataSource;

  DailyAttendanceRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<DailyAttendance>> fetchTodayAttendance({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _localDataSource.getStoredTodayAttendance();
      if (cached != null) return Right(cached);
    }

    final result = await _remoteDataSource.fetchTodayAttendance();

    return result.match((failure) => Left(failure), (response) async {
      final data = response.listDailyAttendance?.firstOrNull;

      if (data == null) {
        return Left(
          const Failure.unexpected(errorMessage: 'noAttendanceToday'),
        );
      }

      await _localDataSource.saveStoredTodayAttendance(data);
      return Right(data);
    });
  }

  @override
  Future<Result<MonthlyAttendanceResult>> fetchMonthlyAttendance({
    required int year,
    required int month,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _localDataSource.getStoredMonthlyAttendance(
        year: year,
        month: month,
      );
      final lastUpdated = _localDataSource.getMonthlyLastUpdated();
      if (cached != null && lastUpdated != null) {
        return Right(
          MonthlyAttendanceResult(list: cached, lastUpdated: lastUpdated),
        );
      }
    }

    final result = await _remoteDataSource.fetchMonthlyAttendance(
      DailyAttendanceRequest(year: year, month: month),
    );

    return result.match((failure) => Left(failure), (response) async {
      final list = response.listDailyAttendance ?? [];
      final now = DateTime.now();
      await _localDataSource.saveStoredMonthlyAttendance(
        list,
        year: year,
        month: month,
      );
      await _localDataSource.saveMonthlyLastUpdated(now);
      return Right(MonthlyAttendanceResult(list: list, lastUpdated: now));
    });
  }
}
