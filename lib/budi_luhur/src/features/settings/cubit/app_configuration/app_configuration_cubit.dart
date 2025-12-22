import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_configuration_cubit.freezed.dart';
part 'app_configuration_state.dart';

class AppConfigurationCubit extends Cubit<AppConfigurationState> {
  final AppConfigurationRepository _appConfigurationRepository;

  AppConfigurationCubit(this._appConfigurationRepository)
    : super(const _Initial());

  Future<void> fetchAppConfiguration() async {
    emit(_Loading());

    try {
      final result = await _appConfigurationRepository.fetchAppConfiguration();

      final data = result.appConfiguration;

      emit(_Success(appConfiguration: data));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }

  AppConfiguration? get getAppConfiguration => state.maybeWhen(
    success: (appConfiguration) => appConfiguration,
    orElse: () => null,
  );

  String? get getAndroidLink => getAppConfiguration?.androidAppLink;

  String? get getIOSLink => getAppConfiguration?.iosAppLink;

  String? get getAndroidAppVersion => getAppConfiguration?.androidAppVersion;

  String? get getIOSAppVersion => getAppConfiguration?.iosAppVersion;

  bool get getForceUpdate => getAppConfiguration?.forceAppUpdate ?? false;

  bool get getAppMaintenance => getAppConfiguration?.appMaintenance ?? false;

  String? get getFileUploadSizeLimit =>
      getAppConfiguration?.fileUploadSizeLimit;
}
