import '../../core/dependencies_injection/get_it_instance.dart';
import 'bloc/auth_bloc.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'repository/auth_repository.dart';
import 'repository/auth_repository_impl.dart';

void initAuthDI() {
  sI.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sI<AuthRemoteDataSource>(),
      sI<AuthLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sI.registerFactory<AuthBloc>(() => AuthBloc(sI<AuthRepository>()));
}
