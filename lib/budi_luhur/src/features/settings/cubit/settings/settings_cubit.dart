import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  final BiometricAuth _biometricAuth;

  SettingsCubit(this._settingsRepository, this._biometricAuth)
    : super(const _Initial()) {
    loadBiometricStatus();
  }

  Future<void> loadBiometricStatus() async {
    emit(const SettingsState.loading());
    try {
      bool status = _settingsRepository.getBiometricStatus();

      emit(SettingsState.success(biometricLogin: status));
    } catch (e) {
      emit(SettingsState.failure(e.toString()));
    }
  }

  Future<void> toggleBiometricLogin({required bool enable}) async {
    final prevStatus = _settingsRepository.getBiometricStatus();
    emit(const SettingsState.loading());

    try {
      if (enable) {
        final passed = await _biometricAuth.biometricAuth();

        if (!passed) {
          emit(
            SettingsState.success(
              biometricLogin: prevStatus,
              showFeedback: false,
            ),
          );
          return;
        }
      }

      await _settingsRepository.setBiometricStatus(enable);

      emit(SettingsState.success(biometricLogin: enable, showFeedback: true));
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.userRequestedFallback) {
        emit(
          SettingsState.success(
            biometricLogin: prevStatus,
            showFeedback: false,
          ),
        );
        return;
      }

      emit(SettingsState.failure(e.code.name));
    } catch (e) {
      emit(SettingsState.failure(e.toString()));
    }
  }

  bool get getBiometricLoginStatus => _settingsRepository.getBiometricStatus();
}
