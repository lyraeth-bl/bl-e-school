part of 'device_token_bloc.dart';

@freezed
abstract class DeviceTokenEvent with _$DeviceTokenEvent {
  const factory DeviceTokenEvent.started() = _Started;

  const factory DeviceTokenEvent.postRequested() = _PostRequested;
}
