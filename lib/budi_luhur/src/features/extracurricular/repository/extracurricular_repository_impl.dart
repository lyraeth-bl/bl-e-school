import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class ExtracurricularRepositoryImpl implements ExtracurricularRepository {
  final ExtracurricularLocalDataSource _localDataSource;
  final ExtracurricularRemoteDataSource _remoteDataSource;

  ExtracurricularRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Result<ExtracurricularResponse>> fetchExtracurricular() async {
    final response = await _remoteDataSource.fetchExtracurricular();

    return response.match(
      (failure) => Left(failure),
      (ExtracurricularResponse extracurricularResponse) =>
          Right(extracurricularResponse),
    );
  }

  @override
  List<Extracurricular>? getStoredExtracurricular() =>
      _localDataSource.getStoredExtracurricular();

  @override
  Future<Unit> saveExtracurricular(
    List<Extracurricular> listExtracurricular,
  ) async => await _localDataSource.saveExtracurricular(listExtracurricular);
}
