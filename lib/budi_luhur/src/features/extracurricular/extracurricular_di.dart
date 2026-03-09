import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initExtracurricularDI() async {
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
