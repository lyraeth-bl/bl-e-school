import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class DisciplineRemoteDataSource {
  Future<Result<MeritResponse>> fetchMerit(DisciplineParams params);

  Future<Result<DemeritResponse>> fetchDemerit(DisciplineParams params);
}

class DisciplineRemoteDataSourceImpl implements DisciplineRemoteDataSource {
  @override
  Future<Result<DemeritResponse>> fetchDemerit(DisciplineParams params) async {
    final Map<String, dynamic> query = {
      if ((params.schoolSession ?? '').isNotEmpty)
        "Tajaran": params.schoolSession,
      if ((params.semester ?? '').isNotEmpty) "Semester": params.semester,
    };

    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.demeritSanctum,
        queryParameters: query,
      );

      return Right(DemeritResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }

  @override
  Future<Result<MeritResponse>> fetchMerit(DisciplineParams params) async {
    final Map<String, dynamic> query = {
      if ((params.schoolSession ?? '').isNotEmpty)
        "Tajaran": params.schoolSession,
      if ((params.semester ?? '').isNotEmpty) "Semester": params.semester,
    };

    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.meritSanctum,
        queryParameters: query,
      );

      return Right(MeritResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
