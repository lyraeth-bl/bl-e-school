import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initAppConfigDI() async {
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
