import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initDeviceTokenDI() async {
  sI.registerLazySingleton<DeviceTokenRepository>(
    () => DeviceTokenRepositoryImpl(sI<DeviceTokenRemoteDataSource>()),
  );

  sI.registerLazySingleton<DeviceTokenRemoteDataSource>(
    () => DeviceTokenRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<DeviceTokenLocalDataSource>(
    () => DeviceTokenLocalDataSourceImpl(),
  );

  // sI.registerFactory<DeviceTokenBloc>(
  //   () => DeviceTokenBloc(sI<DeviceTokenRepository>()),
  // );
}
