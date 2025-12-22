part of 'app_configuration_cubit.dart';

@freezed
abstract class AppConfigurationState with _$AppConfigurationState {
  const factory AppConfigurationState.initial() = _Initial;

  const factory AppConfigurationState.loading() = _Loading;

  const factory AppConfigurationState.success({
    required AppConfiguration appConfiguration,
  }) = _Success;

  const factory AppConfigurationState.failure(String errorMessage) = _Failure;
}
