import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/sessions_local_data_source.dart';
import 'data/datasources/sessions_remote_data_source.dart';
import 'presentation/bloc/sessions_bloc.dart';
import 'repository/sessions_repository.dart';
import 'repository/sessions_repository_impl.dart';

void initSessionsDI() {
  sI.registerLazySingleton<SessionsRepository>(
    () => SessionsRepositoryImpl(
      sI<SessionsRemoteDataSource>(),
      sI<SessionsLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<SessionsLocalDataSource>(
    () => SessionsLocalDataSourceImpl(),
  );

  sI.registerLazySingleton<SessionsRemoteDataSource>(
    () => SessionsRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<SessionsBloc>(
    () => SessionsBloc(sI<SessionsRepository>()),
  );
}
