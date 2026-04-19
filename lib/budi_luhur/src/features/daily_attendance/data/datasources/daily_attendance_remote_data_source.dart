import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/daily_attendance_request/daily_attendance_request.dart';
import '../model/daily_attendance_response/daily_attendance_response.dart';
import '../model/today_attendance_response/today_attendance_response.dart';

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
