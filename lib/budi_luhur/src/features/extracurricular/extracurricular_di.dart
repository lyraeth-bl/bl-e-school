import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/extracurricular_local_data_source.dart';
import 'data/datasources/extracurricular_remote_data_source.dart';
import 'repository/extracurricular_repository.dart';
import 'repository/extracurricular_repository_impl.dart';
import 'screen/bloc/extracurricular_bloc.dart';

void initExtracurricularDI() {
  sI.registerLazySingleton<ExtracurricularRepository>(
    () => ExtracurricularRepositoryImpl(
      sI<ExtracurricularLocalDataSource>(),
      sI<ExtracurricularRemoteDataSource>(),
    ),
  );

  sI.registerLazySingleton<ExtracurricularLocalDataSource>(
    () => ExtracurricularLocalDataSourceImpl(),
  );

  sI.registerLazySingleton<ExtracurricularRemoteDataSource>(
    () => ExtracurricularRemoteDataSourceImpl(),
  );

  sI.registerFactory<ExtracurricularBloc>(
    () => ExtracurricularBloc(sI<ExtracurricularRepository>()),
  );
}
