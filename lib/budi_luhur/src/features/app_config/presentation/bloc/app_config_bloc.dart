import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure/failure.dart';
import '../../data/model/app_config/app_config.dart';
import '../../repository/app_config_repository.dart';

part 'app_config_bloc.freezed.dart';
part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfigRepository _appConfigRepository;

  AppConfigBloc(this._appConfigRepository)
    : super(const AppConfigState.initial()) {
    on<_AppConfigRequested>(_onAppConfigRequested);
  }

  Future<void> _onAppConfigRequested(
    _AppConfigRequested event,
    Emitter<AppConfigState> emit,
  ) async {
    if (!event.forceRefresh && state is _Success) return;

    final storedAppConfigData = _appConfigRepository.getStoredAppConfig();

    if (!event.forceRefresh && storedAppConfigData != null) {
      emit(AppConfigState.success(appConfig: storedAppConfigData));
      debugPrint("AppConfigState.success with local data");
      return;
    }

    emit(const AppConfigState.loading());

    final result = await _appConfigRepository.fetchAppConfig();

    final failure = result.match((f) => f, (_) => null);
    final appConfigResponse = result.match((_) => null, (r) => r);

    if (failure != null) {
      emit(AppConfigState.failure(failure));
      return;
    }

    if (appConfigResponse != null) {
      await _appConfigRepository.storeAppConfig(
        appConfigResponse.appConfig.first,
      );
      debugPrint("_appConfigRepository.storeAppConfig() success");
      emit(
        AppConfigState.success(appConfig: appConfigResponse.appConfig.first),
      );
    }
  }

  bool get isAppMaintenance => state.maybeWhen(
    success: (appConfig) => appConfig.appMaintenance,
    orElse: () => false,
  );
}
