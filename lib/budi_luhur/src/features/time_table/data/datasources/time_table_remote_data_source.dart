import 'package:fpdart/fpdart.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/time_table_response/time_table_response.dart';

abstract class TimeTableRemoteDataSource {
  Future<Result<TimeTableResponse>> fetchTimeTable({required String kelas});
}

class TimeTableRemoteDataSourceImpl implements TimeTableRemoteDataSource {
  @override
  Future<Result<TimeTableResponse>> fetchTimeTable({
    required String kelas,
  }) async {
    String newKelas = kelas;

    if (newKelas.isNotEmpty && newKelas.endsWith("1")) {
      newKelas = newKelas.substring(0, newKelas.length - 1);
    }

    if (newKelas.startsWith("XIIANIMASI")) {
      newKelas = "XIIANI";
    } else if (newKelas.startsWith("XIANIMASI")) {
      newKelas = "XIANI";
    } else if (newKelas.startsWith("XANIMASI")) {
      newKelas = "XANI";
    }

    final Map<String, dynamic> queryParameters = {'kelas': newKelas};

    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.timeTable,
        queryParameters: queryParameters,
      );

      return Right(TimeTableResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
