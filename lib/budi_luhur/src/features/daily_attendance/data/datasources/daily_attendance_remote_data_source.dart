import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class DailyAttendanceRemoteDataSource {
  Future<Result<TodayAttendanceResponse>> fetchTodayAttendance();

  Future<Result<DailyAttendanceResponse>> fetchMonthlyAttendance(
    DailyAttendanceRequest dailyAttendanceRequest,
  );
}

class DailyAttendanceRemoteDataSourceImpl
    implements DailyAttendanceRemoteDataSource {
  @override
  Future<Result<DailyAttendanceResponse>> fetchMonthlyAttendance(
    DailyAttendanceRequest dailyAttendanceRequest,
  ) async {
    try {
      final data = dailyAttendanceRequest.toJson();

      final response = await ApiClient.get(
        url: ApiEndpoints.attendanceSanctum,
        data: data,
      );

      return Right(DailyAttendanceResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }

  @override
  Future<Result<TodayAttendanceResponse>> fetchTodayAttendance() async {
    try {
      final response = await ApiClient.get(
        url: "${ApiEndpoints.attendanceSanctum}/today",
      );

      return Right(TodayAttendanceResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.unexpected(errorMessage: "noAttendanceToday"));
    }
  }
}
