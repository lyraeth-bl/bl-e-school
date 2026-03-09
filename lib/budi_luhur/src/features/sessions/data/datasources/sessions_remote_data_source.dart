import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class SessionsRemoteDataSource {
  Future<Result<MeResponse>> fetchMe();
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  @override
  Future<Result<MeResponse>> fetchMe() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.meSanctum);

      return Right(MeResponse.fromJson(response));
    } catch (e, st) {
      return Left(Failure.fromDio(e, st));
    }
  }
}
