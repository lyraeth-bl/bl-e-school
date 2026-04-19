import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/extracurricular_response/extracurricular_response.dart';

abstract class ExtracurricularRemoteDataSource {
  Future<Result<ExtracurricularResponse>> fetchExtracurricular();
}

class ExtracurricularRemoteDataSourceImpl
    implements ExtracurricularRemoteDataSource {
  @override
  Future<Result<ExtracurricularResponse>> fetchExtracurricular() async {
    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.extracurricularSanctum,
      );

      return Right(ExtracurricularResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
