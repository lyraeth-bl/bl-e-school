import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

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
