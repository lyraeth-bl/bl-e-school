import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/discipline_local_data_source.dart';
import 'data/datasources/discipline_remote_data_source.dart';
import 'presentation/bloc/discipline_bloc.dart';
import 'repository/discipline_repository.dart';
import 'repository/discipline_repository_impl.dart';

void initDisciplineDI() {
  sI.registerLazySingleton<DisciplineRepository>(
    () => DisciplineRepositoryImpl(
      sI<DisciplineRemoteDataSource>(),
      sI<DisciplineLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<DisciplineLocalDataSource>(
    () => DisciplineLocalDataSourceImpl(),
  );

  sI.registerLazySingleton<DisciplineRemoteDataSource>(
    () => DisciplineRemoteDataSourceImpl(),
  );

  sI.registerFactory<DisciplineBloc>(
    () => DisciplineBloc(sI<DisciplineRepository>()),
  );
}
