import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/device_token_local_data_source.dart';
import 'data/datasources/device_token_remote_data_source.dart';
import 'repository/device_token_repository.dart';
import 'repository/device_token_repository_impl.dart';

void initDeviceTokenDI() {
  sI.registerLazySingleton<DeviceTokenRepository>(
    () => DeviceTokenRepositoryImpl(sI<DeviceTokenRemoteDataSource>()),
  );

  sI.registerLazySingleton<DeviceTokenRemoteDataSource>(
    () => DeviceTokenRemoteDataSourceImpl(),
  );

  sI.registerLazySingleton<DeviceTokenLocalDataSource>(
    () => DeviceTokenLocalDataSourceImpl(),
  );
}
