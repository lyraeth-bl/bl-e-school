import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/datasources/extracurricular_local_data_source.dart';
import '../data/datasources/extracurricular_remote_data_source.dart';
import '../data/model/extracurricular/extracurricular.dart';
import '../data/model/extracurricular_response/extracurricular_response.dart';
import 'extracurricular_repository.dart';

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
