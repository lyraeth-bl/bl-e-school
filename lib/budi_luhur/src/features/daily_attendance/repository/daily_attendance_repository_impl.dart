import 'package:fpdart/fpdart.dart';

import '../../../core/failure/failure.dart';
import '../../../utils/shared/types/types.dart';
import '../data/datasources/daily_attendance_local_data_source.dart';
import '../data/datasources/daily_attendance_remote_data_source.dart';
import '../data/model/daily_attendance/daily_attendance.dart';
import '../data/model/daily_attendance_request/daily_attendance_request.dart';
import '../data/model/monthly_attendance_result/monthly_attendance_result.dart';
import '../data/model/today_attendance_response/today_attendance_response.dart';
import 'daily_attendance_repository.dart';

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

    return result.match((failure) => Left(failure), (
      TodayAttendanceResponse todayAttendanceResponse,
    ) async {
      final todayAttendance = todayAttendanceResponse.dailyAttendance;

      if (todayAttendance == null) {
        return Left(Failure.unexpected(errorMessage: "noAttendanceToday"));
      }

      await _localDataSource.saveStoredTodayAttendance(todayAttendance);
      return Right(todayAttendance);
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
