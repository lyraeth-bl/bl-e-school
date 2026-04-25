import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/academic_result_response/academic_result_response.dart';
import '../data/datasources/academic_result_remote_data_source.dart';
import 'academic_result_repository.dart';

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
