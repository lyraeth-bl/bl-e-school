import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/academic_result_remote_data_source.dart';
import 'presentation/bloc/academic_result_bloc.dart';
import 'repository/academic_result_repository.dart';
import 'repository/academic_result_repository_impl.dart';

void initAcademicResultDI() {
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
