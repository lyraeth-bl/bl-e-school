import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

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
