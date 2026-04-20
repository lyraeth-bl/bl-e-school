import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/demerit_response/demerit_response.dart';
import '../model/merit_response/merit_response.dart';
import '../model/params/discipline_params.dart';

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
