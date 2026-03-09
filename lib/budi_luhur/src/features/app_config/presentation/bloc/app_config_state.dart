part of 'app_config_bloc.dart';

@freezed
abstract class AppConfigState with _$AppConfigState {
  const factory AppConfigState.initial() = _Initial;

  const factory AppConfigState.loading() = _Loading;

  const factory AppConfigState.success({required AppConfig appConfig}) =
      _Success;

  const factory AppConfigState.failure(Failure failure) = _Failure;
}
