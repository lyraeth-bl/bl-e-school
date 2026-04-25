import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/app_config_local_data_source.dart';
import 'data/datasources/app_config_remote_data_source.dart';
import 'presentation/bloc/app_config_bloc.dart';
import 'repository/app_config_repository.dart';
import 'repository/app_config_repository_impl.dart';

void initAppConfigDI() async {
  sI.registerLazySingleton<AppConfigRepository>(
    () => AppConfigRepositoryImpl(
      sI<AppConfigLocalDataSource>(),
      sI<AppConfigRemoteDataSource>(),
    ),
  );

  sI.registerLazySingleton<AppConfigLocalDataSource>(
    () => AppConfigLocalDataSourceImpl(),
  );
  sI.registerLazySingleton<AppConfigRemoteDataSource>(
    () => AppConfigRemoteDataSourceImpl(),
  );

  sI.registerFactory<AppConfigBloc>(
    () => AppConfigBloc(sI<AppConfigRepository>()),
  );
}
