part of 'app_localization_cubit.dart';

/// Represents the state for the [AppLocalizationCubit].
///
/// This state holds the current locale of the application.
class AppLocalizationState {
  /// The current locale of the application.
  final Locale language;

  /// Creates a new instance of [AppLocalizationState].
  ///
  /// [language] is the locale to be used by the application.
  AppLocalizationState(this.language);
}
