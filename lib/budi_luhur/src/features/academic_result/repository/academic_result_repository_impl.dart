import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class AcademicResultRepositoryImpl implements AcademicResultRepository {
  final AcademicResultRemoteDataSource _remoteDataSource;

  AcademicResultRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<AcademicResultResponse>> getResult() async {
    final response = await _remoteDataSource.getResult();

    return response.match(
      (failure) => Left(failure),
      (AcademicResultResponse academicResultResponse) =>
          Right(academicResultResponse),
    );
  }
}
