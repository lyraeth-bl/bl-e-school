part of 'app_localization_cubit.dart';

/// Represents the state for the [AppLocalizationCubit].
///
/// This sealed class, built with `freezed`, defines the possible states related
/// to application localization. It ensures that the state objects are immutable.
@freezed
abstract class AppLocalizationState with _$AppLocalizationState {
  /// Represents the primary state where the application has a determined locale.
  ///
  /// This factory creates an immutable state object that holds the current
  /// language setting.
  ///
  /// - [language]: The active [Locale] for the application.
  const factory AppLocalizationState.initial({
    required Locale language,
  }) = _Initial;
}
