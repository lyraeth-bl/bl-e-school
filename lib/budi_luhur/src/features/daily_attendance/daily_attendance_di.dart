import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initDailyAttendanceDI() async {
  sI.registerLazySingleton<DailyAttendanceRepository>(
    () => DailyAttendanceRepositoryImpl(
      sI<DailyAttendanceRemoteDataSource>(),
      sI<DailyAttendanceLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<DailyAttendanceLocalDataSource>(
    () => DailyAttendanceLocalDataSourceImpl(),
  );
  sI.registerLazySingleton<DailyAttendanceRemoteDataSource>(
    () => DailyAttendanceRemoteDataSourceImpl(),
  );

  sI.registerFactory<TodayAttendanceBloc>(
    () => TodayAttendanceBloc(sI<DailyAttendanceRepository>()),
  );
  sI.registerFactory<MonthlyAttendanceBloc>(
    () => MonthlyAttendanceBloc(sI<DailyAttendanceRepository>()),
  );
}
