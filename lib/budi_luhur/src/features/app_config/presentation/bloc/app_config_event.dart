part of 'app_config_bloc.dart';

@freezed
abstract class AppConfigEvent with _$AppConfigEvent {
  const factory AppConfigEvent.started() = _Started;

  const factory AppConfigEvent.appConfigRequested({
    @Default(false) bool forceRefresh,
  }) = _AppConfigRequested;
}
