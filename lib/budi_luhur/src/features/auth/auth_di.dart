import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/bloc/auth_bloc.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bl_e_school/budi_luhur/src/features/auth/repository/auth_repository_impl.dart';

Future<void> initAuthDI() async {
  sI.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sI<AuthRemoteDataSource>(),
      sI<AuthLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sI.registerFactory<AuthBloc>(() => AuthBloc(sI<AuthRepository>()));
}
