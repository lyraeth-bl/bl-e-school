import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/academic_calendar_local_data_source.dart';
import 'data/datasources/academic_calendar_remote_data_source.dart';
import 'presentation/bloc/academic_calendar_bloc.dart';
import 'repository/academic_calendar_repository.dart';
import 'repository/academic_calendar_repository_impl.dart';

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
