part of 'device_token_bloc.dart';

@freezed
class DeviceTokenState with _$DeviceTokenState {
  const factory DeviceTokenState.initial() = _Initial;

  const factory DeviceTokenState.loading() = _Loading;

  const factory DeviceTokenState.success({required DeviceToken deviceToken}) =
      _Success;

  const factory DeviceTokenState.failure(Failure failure) = _Failure;
}
