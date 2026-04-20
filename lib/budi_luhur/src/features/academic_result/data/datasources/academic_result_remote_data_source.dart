import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/utils_export.dart';

abstract class AcademicResultRemoteDataSource {
  Future<Result<AcademicResultResponse>> getResult();
}

class AcademicResultRemoteDataSourceImpl
    implements AcademicResultRemoteDataSource {
  @override
  Future<Result<AcademicResultResponse>> getResult() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.resultSanctum);

      return Right(AcademicResultResponse.fromJson(response));
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }
}
