import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initAcademicCalendarDI() async {
  sI.registerLazySingleton<AcademicCalendarRepository>(
    () => AcademicCalendarRepositoryImpl(
      sI<AcademicCalendarRemoteDataSource>(),
      sI<AcademicCalendarLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<AcademicCalendarRemoteDataSource>(
    () => AcademicCalendarRemoteDataSourceImpl(),
  );
  sI.registerLazySingleton<AcademicCalendarLocalDataSource>(
    () => AcademicCalendarLocalDataSourceImpl(),
  );

  sI.registerFactory<AcademicCalendarBloc>(
    () => AcademicCalendarBloc(sI<AcademicCalendarRepository>()),
  );
}
