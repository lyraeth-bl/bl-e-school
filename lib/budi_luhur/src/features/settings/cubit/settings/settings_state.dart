part of 'settings_cubit.dart';

/// Represents the different states for the [SettingsCubit].
@freezed
abstract class SettingsState with _$SettingsState {
  /// The initial state, indicating that no settings have been loaded yet.
  const factory SettingsState.initial() = _Initial;

  /// The loading state, indicating that settings are currently being fetched or updated.
  const factory SettingsState.loading() = _Loading;

  /// The success state, indicating that an operation has completed successfully.
  ///
  /// This state carries the current status of the biometric login setting.
  const factory SettingsState.success({
    /// Whether biometric login is enabled or not.
    @Default(false) bool biometricLogin,
  }) = _Success;

  /// The failure state, indicating that an error has occurred.
  ///
  /// This state contains an error message describing the failure.
  const factory SettingsState.failure(
    /// The error message.
    String errorMessage,
  ) = Failure;
}
