import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

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
