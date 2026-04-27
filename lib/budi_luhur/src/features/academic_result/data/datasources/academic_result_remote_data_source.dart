import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/utils_export.dart';
import '../models/academic_result_response/academic_result_response.dart';

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
