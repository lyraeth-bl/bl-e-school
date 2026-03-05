import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class DisciplineRepositoryImpl implements DisciplineRepository {
  final DisciplineLocalDataSource _localDataSource;
  final DisciplineRemoteDataSource _remoteDataSource;

  DisciplineRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<DemeritResponse>> fetchDemerit(DisciplineParams params) async {
    final response = await _remoteDataSource.fetchDemerit(params);

    return response.match(
      (failure) => Left(failure),
      (DemeritResponse demeritResponse) => Right(demeritResponse),
    );
  }

  @override
  Future<Result<MeritResponse>> fetchMerit(DisciplineParams params) async {
    final response = await _remoteDataSource.fetchMerit(params);

    return response.match(
      (failure) => Left(failure),
      (MeritResponse meritResponse) => Right(meritResponse),
    );
  }

  @override
  List<Demerit>? getStoredDemerit() => _localDataSource.getStoredDemerit();

  @override
  List<Merit>? getStoredMerit() => _localDataSource.getStoredMerit();

  @override
  Future<Unit> storeDemerit(List<Demerit> listDemerit) async =>
      _localDataSource.storeDemerit(listDemerit);

  @override
  Future<Unit> storeMerit(List<Merit> listMerit) async =>
      _localDataSource.storeMerit(listMerit);
}
