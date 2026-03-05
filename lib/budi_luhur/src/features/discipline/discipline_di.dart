import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initDisciplineDI() async {
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
