import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token_bloc.freezed.dart';
part 'device_token_event.dart';
part 'device_token_state.dart';

class DeviceTokenBloc extends Bloc<DeviceTokenEvent, DeviceTokenState> {
  final DeviceTokenRepository _repository;

  DeviceTokenBloc(this._repository) : super(const DeviceTokenState.initial()) {
    on<_PostRequested>(_onPostRequested);
  }

  Future<void> _onPostRequested(
    _PostRequested event,
    Emitter<DeviceTokenState> emit,
  ) async {
    final deviceTokenStoredData = _repository.getStoredDeviceToken();

    if (deviceTokenStoredData != null) {
      emit(DeviceTokenState.success(deviceToken: deviceTokenStoredData));
      debugPrint("DeviceTokenState.success with local data");
      return;
    }

    emit(const DeviceTokenState.loading());

    final result = await _repository.postDeviceToken();

    final failure = result.fold((f) => f, (_) => null);
    final deviceTokenResponse = result.fold((_) => null, (r) => r);

    if (failure != null) {
      emit(DeviceTokenState.failure(failure));
      return;
    }

    if (deviceTokenResponse != null) {
      await _repository.storeDeviceToken(deviceTokenResponse.deviceToken);
      debugPrint("_repository.storeDeviceToken success");
      emit(
        DeviceTokenState.success(deviceToken: deviceTokenResponse.deviceToken),
      );
    }
  }
}
