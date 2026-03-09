import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initAcademicResultDI() async {
  sI.registerLazySingleton<AcademicResultRepository>(
    () => AcademicResultRepositoryImpl(sI<AcademicResultRemoteDataSource>()),
  );

  sI.registerLazySingleton<AcademicResultRemoteDataSource>(
    () => AcademicResultRemoteDataSourceImpl(),
  );

  sI.registerFactory<AcademicResultBloc>(
    () => AcademicResultBloc(sI<AcademicResultRepository>()),
  );
}
