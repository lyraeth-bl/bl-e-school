import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/academic_calendar_request/academic_calendar_request.dart';
import '../model/academic_calendar_response/academic_calendar_response.dart';

abstract class AcademicCalendarRemoteDataSource {
  Future<Result<AcademicCalendarResponse>> fetchMonthlyAcademic({
    required AcademicCalendarRequest academicCalendarRequest,
    bool forceRefresh = false,
  });
}

class AcademicCalendarRemoteDataSourceImpl
    implements AcademicCalendarRemoteDataSource {
  @override
  Future<Result<AcademicCalendarResponse>> fetchMonthlyAcademic({
    required AcademicCalendarRequest academicCalendarRequest,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await ApiClient.get(
        url:
            "${ApiEndpoints.academicCalendarSanctum}/${academicCalendarRequest.year}/${academicCalendarRequest.month}/${academicCalendarRequest.unit}",
      );

      return Right(AcademicCalendarResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
