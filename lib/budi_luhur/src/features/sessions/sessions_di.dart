import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/datasources/sessions_local_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/data/datasources/sessions_remote_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/presentation/bloc/sessions_bloc.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/repository/sessions_repository.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/repository/sessions_repository_impl.dart';

Future<void> initSessionsDI() async {
  sI.registerLazySingleton<SessionsRepository>(
    () => SessionsRepositoryImpl(
      sI<SessionsRemoteDataSource>(),
      sI<SessionsLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<SessionsLocalDataSource>(
    () => SessionsLocalDataSourceImpl(),
  );

  sI.registerLazySingleton<SessionsRemoteDataSource>(
    () => SessionsRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<SessionsBloc>(
    () => SessionsBloc(sI<SessionsRepository>()),
  );
}
