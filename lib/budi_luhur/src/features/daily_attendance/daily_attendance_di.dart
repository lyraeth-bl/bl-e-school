import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/daily_attendance_local_data_source.dart';
import 'data/datasources/daily_attendance_remote_data_source.dart';
import 'presentation/bloc/monthly_attendance/monthly_attendance_bloc.dart';
import 'presentation/bloc/today_attendance/today_attendance_bloc.dart';
import 'repository/daily_attendance_repository.dart';
import 'repository/daily_attendance_repository_impl.dart';

void initDailyAttendanceDI() {
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
