import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/datasources/time_table_local_data_source.dart';
import '../data/datasources/time_table_remote_data_source.dart';
import '../data/model/time_table/time_table.dart';
import '../data/model/time_table_response/time_table_response.dart';
import 'time_table_repository.dart';

class TimeTableRepositoryImpl implements TimeTableRepository {
  final TimeTableLocalDataSource _localDataSource;
  final TimeTableRemoteDataSource _remoteDataSource;

  TimeTableRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<TimeTableResponse>> fetchTimeTable({
    required String kelas,
  }) async {
    final response = await _remoteDataSource.fetchTimeTable(kelas: kelas);

    return response.match(
      (failure) => Left(failure),
      (TimeTableResponse timeTableRespose) => Right(timeTableRespose),
    );
  }

  @override
  List<TimeTable>? getStoredTimeTable() =>
      _localDataSource.getStoredTimeTable();

  @override
  Future<Unit> storeTimeTable(List<TimeTable> listTimeTable) async =>
      await _localDataSource.storeTimeTable(listTimeTable);
}
