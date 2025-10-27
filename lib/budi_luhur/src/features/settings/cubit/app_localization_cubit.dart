import 'dart:ui';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/settings/repository/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'app_localization_state.dart';

/// A [Cubit] that manages the application's localization (language).
///
/// This cubit is responsible for initializing the app's locale based on
/// saved settings and updating it when the user selects a new language.
class AppLocalizationCubit extends Cubit<AppLocalizationState> {
  final SettingsRepository _settingsRepository;

  /// Creates an instance of [AppLocalizationCubit].
  ///
  /// Initializes the locale by retrieving the current language code
  /// from the [_settingsRepository].
  AppLocalizationCubit(this._settingsRepository)
    : super(
        AppLocalizationState(
          Utils.getLocaleFromLanguageCode(
            _settingsRepository.getCurrentLanguageCode(),
          ),
        ),
      );

  /// Changes the application's language.
  ///
  /// This method persists the new [languageCode] using the [_settingsRepository],
  /// updates the locale globally using the `Get` package, and emits a new
  /// [AppLocalizationState] to rebuild widgets that depend on the locale.
  void changeLanguage(String languageCode) {
    _settingsRepository.setCurrentLanguageCode(languageCode);

    Get.updateLocale(Utils.getLocaleFromLanguageCode(languageCode));
    emit(AppLocalizationState(Utils.getLocaleFromLanguageCode(languageCode)));
  }
}
