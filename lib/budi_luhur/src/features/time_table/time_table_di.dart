import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/time_table_local_data_source.dart';
import 'data/datasources/time_table_remote_data_source.dart';
import 'presentation/bloc/time_table_bloc.dart';
import 'repository/time_table_repository.dart';
import 'repository/time_table_repository_impl.dart';

void initTimeTableDI() {
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
