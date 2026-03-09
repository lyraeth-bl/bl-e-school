import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initTimeTableDI() async {
  sI.registerLazySingleton<TimeTableRepository>(
    () => TimeTableRepositoryImpl(
      sI<TimeTableRemoteDataSource>(),
      sI<TimeTableLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<TimeTableLocalDataSource>(
    () => TimeTableLocalDataSourceImpl(),
  );
  sI.registerLazySingleton<TimeTableRemoteDataSource>(
    () => TimeTableRemoteDataSourceImpl(),
  );

  sI.registerFactory<TimeTableBloc>(
    () => TimeTableBloc(sI<TimeTableRepository>()),
  );
}
